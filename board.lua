----- Variables -----
to_push = "" -- Content that will be sent to page
thread_builder = "start" -- Replaced each time a thread is completed; temporary storage
old_id = 0 -- Temporary storage for post ID (changed in thread constructor)

----- Functions -----
function split_string(text, with) -- Build a table from strings split at new lines
	local result_table = {}
	local function helper(line)
		table.insert(result_table, line)
		return ""
	end
	helper((text:gsub(with, helper))) -- Black magic from the Lua documentation
	return result_table
end

-- Process inspired by protein synthesis!
function construct(data, post) -- Build each thread from source
	if string.sub(data, 1, 1) == "t" then -- Post is a unique thread, not a reply
		
		-- Publish contents (if applicable)
		if thread_builder ~= "start" then -- Do not publish if first thread
			to_push = to_push .. "<div id = \"thread_" .. old_id .. "\" class = \"thread\">" .. thread_builder .. "<div class = \"post_bottom\"><button id = \"button_" .. old_id .. "\" class = \"open\" onclick = \"void_click('" .. old_id .. "');\">Add Response</button><textarea id = \"respond_to_" .. old_id .. "\" class = \"text_response\" placeholder = \"Enter your response.\"></textarea><button id = \"submit_" .. old_id .. "\" class = \"submit_response_button\">Submit</button></div></div>"
		end
		
		-- Determine thread ID for current thread
		old_id = split_string(string.sub(data, 2), "%S+")[1] -- Get numerical value of post
		
		-- Flush contents to begin new thread
		thread_builder = ""
		
	end
	
	--[[ MIGRATION: POSTING PROCEDURES (SAVE RESOURCES)
	-- Pattern detection for quotations
	found = 0 -- Shows whether a quotation is currently being highlighted
	length_modifier = post:len()
	j = 0 -- Iterator in loop
	while j < length_modifier do -- "For" loop doesn't work because the maximum value cannot change as text is added to the string; quotations toward the end will not work
		j = j + 1 -- Must be present to prevent infinite loop
		if string.sub(post, j, j) then -- Byproduct of looping over an unknown maximum index; ugly but necessary
			if string.sub(post, j, j) == "|" and (j == 1 or string.sub(post, j - 1, j - 1) == ">") and found == 0 then -- "|" character at start of a line, not in a quotation at present?
				found = 1 -- Prevent this from executing again to create more <span> tags
				length_modifier = length_modifier + 20 -- Likely excessive, but it's best to stay on the safe side.
				post = string.sub(post, 1, j - 1) .. "<span class = \"quote\">" .. string.sub(post, j + 1) -- Begin the quotation
			elseif found == 1 and string.sub(post, j + 1, j + 1) == "<" and string.sub(post, j + 2, j + 2) == "b" then -- Identifies whether newline (<br>) is next in string
				found = 0 -- No longer in quotation
				post = string.sub(post, 1, j) .. "</span>" .. string.sub(post, j + 1) -- End quotation
			end
		end
	end
	-- Provisions for no newline (<br>) in post (will still end quotation if it's the last line)
	if found == 1 then
		found = 0
		post = post .. "</span>"
	end
	]]--
	
	-- Determine numerical ID of individual posts (not threads)
	post_id = split_string(string.sub(data, 2), "%S+")[1]
	
	-- Add new post to thread (split for readability)
	thread_builder = thread_builder .. "<div id = \"" .. post_id .. "\" class = \"post\">" -- Begin post
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
lines = split_string(content, "(.-)\r?\n") -- Make a table of lines (second argument is newline)
for i = 1, #lines, 2 do -- Get each unique post (two lines each in source)
	construct(lines[i], lines[i + 1]) -- Send each unique post to construction
end

-- Push stop code to constructor (will build last thread)
construct("tStop", "Stop thread construction")

----- Completion -----
-- Push all contents to page
print(to_push)