module Overcommit::Hook::PreCommit
  class LuaCheck < Base

    MESSAGE_REGEX = /
      ^\s+(?<file>.+)
      :(?<line>\d+)
      :(?<col>\d+)
      :\s+(?<msg>.+)$
    /x
    def run
      result = execute(command, args: applicable_files)
      parse_messages(result.stdout)
    end

    private

    def parse_messages(output)
      repo_root = Overcommit::Utils.repo_root

      output.scan(MESSAGE_REGEX).map do |file, line, col, msg|
        line = line.to_i
        # Obtain the path relative to the root of the repository
        # for nicer output:
        relpath = file.dup
        relpath.slice!("#{repo_root}/")

        text = "#{relpath}:#{line}:#{col}: #{msg}"
        Overcommit::Hook::Message.new(:warning, file, line, text)
      end
    end
  end
end
