FileName = 'todos.md'

function printHelp()
    print("cli-todo basic command line interpreter.")
    print("-- Help:")
    print("- help          : Display this help message.")

    print("-- Action:")
    print("- add <msg>     : Append <msg> at the bottom of file.")
    print("- mark <id>     : Mark msg with <id>, using character 🗸.")
    print("- unmark <id>   : UnMark msg with <id>, leaving it as [ ].")
    print("- delete <id>   : Delete msg with <id>.")

    print("-- List:")
    print("- list          : List all msg with correspondent ids.")
 end

function checkOrCreateFile(filename)
  -- Open the file in read mode to check if it exists
  local file = io.open(filename, "r")

  -- File does not exist, create it and add 0 at the beggining
  if not file then
    file = io.open(filename, "w")

    if file then
      file:write(tostring(0) .. "\n\n")
      print("[+] File", filename, "has been created.")
      file:close()
      return 0
    else
      print("[!] ERROR : file could not be created!!")
      return nil
    end
  end

  local next_id = file:read("n")
  print("[INFO] The next_id from checkOrCreateFile function is", next_id)
  file:close()
  return next_id
end

function addMessage(filename, id, msg)
  local file = io.open(filename, "a")

  if file then
    local formatedMsg = string.format("(%s) [ ] %s\n", id, msg)
    file:write(formatedMsg)
    file:close()
  end
end

function setId(filename, action)
  local file = io.open(filename, "r+")

  if file then
    local current_value = file:read("n")

    if current_value then
      if action == "inc" then
        current_value = current_value + 1
      elseif action == "dec" then
        current_value = current_value - 1
      end

      -- move cursor to top and write value
      file:seek("set", 0)
      file:write(tostring(current_value))
      file:close()
    else
      print("[!] ERROR : number could not be found!!")
    end
  else
    print("[!] ERROR : file could not be open!!")
  end
end

function actOverId(filename, id, action)
  local file = io.open(filename, "r+")
  if file then
    -- Read the file content into a table
    local lines = {}
    for line in file:lines() do
      table.insert(lines, line)
    end

    id = tonumber(id)
    -- Find the line with the matching ID and mark it as completed
    for i, line in ipairs(lines) do
      local taskId = line:match("%((%d+)%)") -- Extract the ID from the line using a pattern match
      print(i, taskId)
      if taskId and tonumber(taskId) == id then
        if action == "mark" then
          lines[i] = line:gsub("%[ %]", "[🗸]") -- Mark the task as completed by replacing "[ ]" with "[🗸]"
          print("[+] Task with ID", id, "marked as completed.")
        elseif action == "unmark" then
          lines[i] = line:gsub("%[%🗸%]", "[ ]") -- Mark the task as completed by replacing "[ ]" with "[🗸]"
          print("[+] Task with ID", id, "marked as not completed.")
        elseif action == "delete" then
          table.remove(lines, i)
          -- Iterate over the table and print key-value pairs
          print("[-] Removed taskId", taskId)
          file = io.open(filename, "w")
        end
        break
      end
    end

    -- Write the modified content back to the file
    file:seek("set", 0) -- Move the file pointer to the beginning
    file:write(lines[1] .. "\n")
    file:write(table.concat({table.unpack(lines, 2)}, "\n")) -- Write the modified lines to the file
    file:write("\n")
    file:close() -- Close the file
  else
    print("[!] Error: Unable to open file", filename)
  end
end

function listTODOs(filename)
  local file = io.open(filename, "r")
  if file then
    for line in file:lines() do
      print(line)
    end
    file:close()
  else
    print("[!] Error: Unable to open file", filename)
  end
end

function processCommand(args)
  -- split command into individual arguments

  -- local args = {}
  -- for arg in command:gmatch("%S+") do
  --  table.insert(args, arg)
  -- end

  -- check command and perform action
  local cmd = args[1]
  if cmd == "help" then
    printHelp()
  elseif cmd == "add" then
    local msg = table.concat({table.unpack(args, 2)}, " ")

    if msg == " " or msg == nil then
      print("[!] ERROR: Given an empty <msg>!!")
    else
      local next_id = checkOrCreateFile(FileName)

      -- Insert value at the end of file
      addMessage(FileName, next_id, msg)
      setId(FileName, "inc")
    end
  elseif cmd == "mark" then
    local id = args[2]
    print("id", id)
    actOverId(FileName, id, "mark")
  elseif cmd == "unmark" then
    local id = args[2]
    actOverId(FileName, id, "unmark")
  elseif cmd == "delete" then
    local id = args[2]
    actOverId(FileName, id, "delete")
    -- setId(FileName, "dec")
  elseif cmd == "list" then
    listTODOs(FileName)
  end
end

processCommand(arg)
