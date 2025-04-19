def sanitize:
  walk(
    if type == "string"
    then
      gsub("\\\\"; "\\\\\\\\") |         # Escape backslashes
      gsub("\r"; "\\\\r")     |          # Escape carriage return
      gsub("\n"; "\\\\n")     |          # Escape newline
      gsub("\t"; "\\\\t")                 # Escape tab
    else .
    end
  );
sanitize
