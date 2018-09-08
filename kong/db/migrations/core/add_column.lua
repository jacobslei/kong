return {
  postgres = {
    up = [[

    ]],
  },

  cassandra = {
    up = [[
      ALTER TABLE routes ADD new_column boolean;
    ]],
  }
}
