# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

if defined?(Jekyll::Assets)
  Jekyll::Assets::Hook.register :env, :after_init do
    append_path Pathutil.new(__dir__).join("../vendor").expand_path.to_s
  end
end
