config_file = File.join Rails.root, "/config/quicksearch_config.yml"
APP_CONFIG = YAML.load_file(config_file)[Rails.env]
