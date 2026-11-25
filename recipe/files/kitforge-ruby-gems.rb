# kitforge-ruby-gems.rb -- written by gen_dockerfile.py (L-009 Ruby kit). Runs in the vendor AND the offline stage.
#
#   ruby kitforge-ruby-gems.rb install DIR [NAME=VERSION ...]
#     `gem install --local` every .gem in DIR (the lockfile's Bundler and source.ruby.gem_updates), then remove every
#     OLDER copy of each NAME that Ruby itself installed: a bundled gem is uninstalled; a default gem's files are
#     deleted from the standard library directories together with its default gemspec, so `require` finds only the
#     fixed release. Fails if an older copy is still installed afterwards.
#   ruby kitforge-ruby-gems.rb floors NAME=VERSION:LEVEL ...
#     raise NAME in Gemfile.lock to at least VERSION with `bundle lock --update NAME --conservative --strict --LEVEL`.
#     A gem the lockfile does not contain is skipped and one already at or above the floor is left alone (a floor
#     never lowers anything); a floor the update cannot reach fails the build.
require "rubygems"
require "rbconfig"

def pairs(args)
  args.map do |a|
    n, v = a.split("=", 2)
    abort "kitforge-ruby-gems: expected NAME=VERSION, got #{a.inspect}" if n.to_s.empty? || v.to_s.empty?
    [n, v]
  end
end

def older(name, want)
  Gem::Specification.reset
  Gem::Specification.select { |s| s.name == name && s.version < want }
end

case ARGV.shift
when "install"
  dir = ARGV.shift.to_s
  gems = Dir[File.join(dir, "*.gem")].sort
  abort "kitforge-ruby-gems: no .gem files in #{dir}" if gems.empty?
  system("gem", "install", "--local", "--no-document", *gems, exception: true)
  pairs(ARGV).each do |name, ver|
    want = Gem::Version.new(ver)
    Gem::Specification.reset # the install ran in a child process: re-read the spec dirs
    fresh = Gem::Specification.find_all_by_name(name, ver).first
    abort "kitforge-ruby-gems: #{name} #{ver} is not installed" unless fresh
    older(name, want).each do |s|
      if s.default_gem?
        # A default gem's spec lists its REPOSITORY paths (lib/json.rb, ext/json/parser/parser.c); what Ruby installed
        # is lib/* under rubylibdir and the compiled extensions under rubyarchdir, at the same relative paths the
        # fixed release's own extension_dir uses (json/ext/parser.so). Measured on 4.0.5: deleting by the raw spec
        # paths removed nothing and `require "json"` still loaded 2.18.0 from the standard library.
        libdir, archdir = RbConfig::CONFIG["rubylibdir"], RbConfig::CONFIG["rubyarchdir"]
        rels = s.files.filter_map { |f| f.delete_prefix("lib/") if f.start_with?("lib/") }
        sos = Dir.glob("**/*.{so,bundle}", base: fresh.extension_dir)
        targets = rels.map { |r| File.join(libdir, r) } + sos.map { |r| File.join(archdir, r) }
        gone = targets.select { |p| File.file?(p) }
        gone.each { |p| File.delete(p) }
        gone.map { |p| File.dirname(p) }.uniq.sort_by { |d| -d.length }.each do |d|
          while d.length > libdir.length && d != archdir && Dir.exist?(d) && Dir.empty?(d)
            Dir.rmdir(d)
            d = File.dirname(d)
          end
        end
        File.delete(s.loaded_from)
        require "fileutils"
        FileUtils.rm_rf(s.full_gem_path) if s.full_gem_path.start_with?(Gem.dir)
        puts "kitforge-ruby-gems: removed default gem #{s.full_name} (#{gone.size} installed files)"
        # Every top-level library of the gem must now load from the fixed release, never the standard library.
        rels.select { |r| r.end_with?(".rb") && !r.include?("/") }.each do |r|
          feats = IO.popen([RbConfig.ruby, "-e", "require ARGV[0]; puts $LOADED_FEATURES", r.delete_suffix(".rb")], &:read)
          feats = feats.lines.map(&:strip)
          stale = feats.select { |f| [libdir, archdir].any? { |d| f.start_with?(d + "/") && targets.include?(f) } }
          ok = $?.success? && stale.empty? && feats.any? { |f| f.start_with?(fresh.full_gem_path + "/") }
          abort "kitforge-ruby-gems: require #{r.delete_suffix('.rb')} does not load #{fresh.full_name} (#{stale.first})" unless ok
          puts "kitforge-ruby-gems: require #{r.delete_suffix('.rb')} loads #{fresh.full_name}"
        end
      else
        system("gem", "uninstall", name, "-v", s.version.to_s, "--ignore-dependencies", "--executables",
               exception: true)
        puts "kitforge-ruby-gems: uninstalled bundled gem #{s.full_name}"
      end
    end
    left = older(name, want)
    abort "kitforge-ruby-gems: #{left.map(&:full_name).join(', ')} still installed" unless left.empty?
  end
when "floors"
  require "bundler"
  locked = ->(name) { Bundler::LockfileParser.new(File.read("Gemfile.lock")).specs.select { |s| s.name == name }.map(&:version) }
  ARGV.each do |arg|
    nv, level = arg.split(":", 2)
    name, ver = pairs([nv]).first
    want = Gem::Version.new(ver)
    have = locked.(name)
    if have.empty?
      puts "kitforge-ruby-gems: floor #{name} >= #{ver}: not in Gemfile.lock, skipped"
      next
    end
    if have.all? { |v| v >= want }
      puts "kitforge-ruby-gems: floor #{name} >= #{ver}: already #{have.max}"
      next
    end
    system("bundle", "lock", "--update", name, "--conservative", "--strict", "--#{level || 'minor'}", exception: true)
    have = locked.(name)
    abort "kitforge-ruby-gems: floor #{name} >= #{ver} not reached by --#{level || 'minor'} (lock has #{have.min})" unless have.all? { |v| v >= want }
    puts "kitforge-ruby-gems: floor #{name} >= #{ver}: now #{have.max}"
  end
else
  abort "usage: kitforge-ruby-gems.rb install DIR [NAME=VERSION ...] | floors NAME=VERSION:LEVEL ..."
end
