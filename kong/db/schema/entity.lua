local Schema = require("kong.db.schema")

local Entity = {}


local entity_errors = {
  NO_NILABLE = "Entities cannot have nilable types.",
  NO_FUNCTIONS = "Entities cannot have function types.",
  MAP_KEY_STRINGS_ONLY = "Entities map keys must be strings.",
  AGGREGATE_ON_BASE_TYPES_ONLY = "Entities aggregates are only allowed on base types."
}


local base_types = {
  string = true,
  number = true,
  boolean = true,
  integer = true,
}


function Entity.new(definition)

  local self, err = Schema.new(definition)
  if not self then
    return nil, err
  end

  for name, field in self:each_field() do
    if field.nilable then
      return nil, entity_errors.NO_NILABLE
    end

    if field.type == "map" then
      if field.keys.type ~= "string" then
        return nil, entity_errors.MAP_KEY_STRINGS_ONLY:format(name)
      end
      if not base_types[field.values.type] then
        return nil, entity_errors.AGGREGATE_ON_BASE_TYPES_ONLY:format(name)
      end

    elseif field.type == "array" or field.type == "set" then
      if not base_types[field.elements.type] then
        return nil, entity_errors.AGGREGATE_ON_BASE_TYPES_ONLY:format(name)
      end

    elseif field.type == "function" then
      return nil, entity_errors.NO_FUNCTIONS
    end
  end

  return self
end


return Entity
