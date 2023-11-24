return {
  settings = {
    yaml = {
      schemaStore = {
        -- see: https://github.com/b0o/SchemaStore.nvim
        enable = false,
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
