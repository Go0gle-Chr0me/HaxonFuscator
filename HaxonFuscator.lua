Script = [[
print'HaxonFuscator made by Google Chrome'
]]

customVarNames = {
  "HaxonNotAxon",
  "HaxonProtoSoon",
  "ThisIsShit",
  "LolYouWillCrackFast",
  "ThisShitIsBroken"
}  

funcrename = {
  ["print"]="print",
  ["_G"]="_G",
  ["getmetatable"]="getmetatable",
  ["warn"]="warn",
  ["error"]="error",
  ["Instance.new"]="Instance.new",
  ["loadstring"]="loadstring",
  ["UDim2.new"]="UDim2.new",
  ["false"]="false",
  ["true"]="true",
  ["Color3.new"]="Color3.new",
  ["Vector3.new"]="Vector3.new",
  ["Vector2.new"]="Vector2.new",
  ["getgenv"]="getgenv",
  ["getrenv"]="getrenv",
  ["getfenv"]="getfenv",
  ["getsenv"]="getsenv",
  ["Enum"]="Enum",
  ["getrawmetatable"]="getrawmetatable",
  ["newcclosure"]="newcclosure",
  ["CFrame.new"]="CFrame.new",
  ["next"]="next",
  ["pairs"]="pairs",
  ["Region3.new"]="Region3.new",
  ["nil"]="nil",
  ["printidentity"]="printidentity",
  ["tostring"]="tostring",
  ["unpack"]="unpack",
  ["debug"]="debug",
  ["bit"]="bit"
}
--CreateVarName
local chars ="1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1I1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1I1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1I1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1IlI1"
local taken = { }
taken[""] = true
local function CreateVar()
  local s = ""
  while taken[s] do
    for i = 1, math.random(5, 15) do
      local c = chars:sub(i,i)
      s = s..c
    end
  end
  taken[s] = true
  return(customVarNames[math.random(1,#customVarNames)].. s)
end
    
--WipeComments
function WipeComment(scr)
  scr = scr:gsub("(%-%-%[(=*)%[.-%]%2%])", "")
  scr = scr:gsub("(%-%-[^\r\n]*)", "")
  return scr
end

--WipeStrings
local function dumpString(x)
  return(x:gsub(".", function(bb) return "\\" .. bb:byte() end) or thing .. "\"")
end
function WipeStrings(scrpt)
  for each in scrpt:gmatch("%b''") do
    scrpt = scrpt:gsub(each, each:gsub("'", '"'))        
  end
  for each in scrpt:gmatch('%b""') do
    each = each:gsub('"', '')  
    scrpt = scrpt:gsub('"'..each..'"', "'"..dumpString(each).."'")       
  end

  return scrpt
end

--CoreFuncRename
function CFR(scrpt)
  for i,v in pairs(funcrename) do
    local pp = CreateVar()
    funcrename[i]= pp
  end
  local setlist = ""
  for i,v in pairs(funcrename) do
    setlist = setlist..("local "..v.."="..i.."; ")
    scrpt = scrpt:gsub(i, v)
  end
  return setlist..scrpt
end

--LocalFuncRename
local library = {}
function LFR(scrpt)
  for fType in scrpt:gmatch("local%s*function%s*([%w_]+)%(") do 
		local replacement = CreateVar()
		if #fType > 5 then
			library[fType] = replacement
			scrpt = scrpt:gsub("function " .. fType, "function " .. replacement)
		end
	end
    
	for fCall in scrpt:gmatch("([%w_]+)%s*%(") do
		if library[fCall] then
			scrpt = scrpt:gsub(fCall .. '%(', library[fCall] .. '%(')
		end
	end
  return scrpt
end

--NonLocalFuncRename
function NLFR(scrpt)
  for fType in scrpt:gmatch("%s*function%s*([%w_]+)%(") do 
    local replacement = CreateVar()
		if #fType > 5 then
			library[fType] = replacement
			scrpt = scrpt:gsub("function " .. fType, "function " .. replacement)
		end
	end

  for fCall in scrpt:gmatch("([%w_]+)%s*%(") do
		if library[fCall] then
			scrpt = scrpt:gsub(fCall .. '%(', library[fCall] .. '%(')
		end
	end
  return scrpt
end

--RemoveWhitespace
function RW(scrpt)
  scrpt = scrpt:gsub("^%s*(.-)%s*$", "%1")
  scrpt = scrpt:gsub("(^%s*).*", "")
  scrpt = scrpt:gsub(" %s+", " ")
  return scrpt
end

--VarRename

function isKeyword(s)
  local s2 = 'and break do else elseif end false for function if in local nil not or repeat return then true until'
  for w in s2:gmatch("(%w+)") do
    if w == s then return true end
  end
  return false
end

function VR(scrpt)
	for each in scrpt:gmatch("local%s*([%w_]*)%s*=%s*") do
    if #each > 3 and not isKeyword(each) then
      local varName = CreateVar()
      scrpt = scrpt:gsub(each," "..varName)       
    end
  end
  return scrpt
end

--obfuscate
function Obfuscate(scr)
  scr = WipeComment(scr)
  scr = WipeStrings(scr)
  scr = LFR(scr)
  scr = NLFR(scr)
  scr = VR(scr)
  scr = CFR(scr)
  scr = RW(scr)

  print(scr)
end

do Obfuscate(Script) end
