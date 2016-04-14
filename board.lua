----- Variables -----
to_push = "" -- Content that will be sent to page
thread_builder = "start" -- Replaced each time a thread is completed; temporary storage

----- Functions -----
function split_string(text) -- Build a table from strings split at new lines
	local result_table = {}
	local function helper(line)
		table.insert(result_table, line)
		return ""
	end
	helper((text:gsub("(.-)\r?\n", helper))) -- Black magic from the Lua documentation
	return result_table
end

-- Process inspired by protein synthesis!
function construct(data, post) -- Build each thread from source
	if string.sub(data, 1, 1) == "t" then -- Post is a unique thread, not a reply
	
		-- Publish contents (if applicable)
		if thread_builder ~= "start" then -- Do not publish if first thread
			to_push = to_push .. "<div class = \"thread\">" .. thread_builder .. "</div>"
		end
		
		-- Flush contents to begin new thread
		thread_builder = ""
		
	end
	
		-- Add new post to thread (split for readability)
		thread_builder = thread_builder .. "<div class = \"post\">" -- Begin post
		thread_builder = thread_builder .. "<div class = \"about\">" .. string.sub(data, 2) .. "</div>" -- Add data
		thread_builder = thread_builder .. "<div class = \"content\">" .. post .. "</div>" -- Add content
		thread_builder = thread_builder .. "</div>" -- End post
		
end

----- Setup -----
-- Get posts currently in file (read-only)
content_file = io.open("source", "r")
content = content_file:read("*all")
content_file:close()

-- Break content into usable information
lines = split_string(content) -- Make a table of lines
for i = 1, #lines, 2 do -- Get each unique post (two lines each in source)
	construct(lines[i], lines[i + 1]) -- Send each unique post to construction
end

-- Push stop code to constructor (will build last thread)
construct("tStop", "Stop thread construction")

----- Completion -----
-- Push all contents to page
print(to_push)