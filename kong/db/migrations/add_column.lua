return {
  postgres = {
    -- TODO
  },

  cassandra = {
    up = [[
      ALTER TABLE routes ADD new_column boolean;
    ]],
  }
}
