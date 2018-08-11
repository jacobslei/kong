return {
  translations = {
    --rename_column("routes", "strip_path", "preserve_path")
    {
      entity = "routes",
      read = function(entity)
        if entity.strip_path ~= nil then
          entity.preserve_path = entity.strip_path
          entity.strip_path = nil
        end

        return entity
      end,
      write = function(entity)
        if entity.preserve_path ~= nil then
          entity.strip_path = entity.preserve_path
        end

        return entity
      end,
    },
  },

  postgres = {
    -- TODO
  },

  cassandra = {
    up = [[
      ALTER TABLE routes ADD preserve_path boolean;
    ]],

    teardown = function(connector)
      -- move old strip_path to new preserve_path
      for rows, err in connector.cluster:iterate("SELECT * FROM routes") do
        for _, row in ipairs(rows) do
          if row.strip_path ~= nil then
            local _, _ = connector:query([[
              UPDATE routes SET preserve_path = ? WHERE id = ?
            ]], { row.strip_path, row.id })
            --[[
            if not ok then
              -- log.error()
            end
            --]]
          end
        end

        -- remove old strip_path column
        local ok, err = connector:query("ALTER TABLE routes DROP strip_path")
        if not ok then
          return nil, err
        end
      end
    end
  }
}
