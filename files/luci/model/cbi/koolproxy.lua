local m, s, o

if luci.sys.call("pgrep koolproxy >/dev/null") == 0 then
	m = Map("koolproxy", translate("KoolProxy"), "%s - %s" %{translate("KoolProxy"), translate("RUNNING")})
else
	m = Map("koolproxy", translate("KoolProxy"), "%s - %s" %{translate("KoolProxy"), translate("NOT RUNNING")})
end

s = m:section(TypedSection, "general", translate("General Setting"))
s.anonymous   = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty     = false

o = s:option(Value, "startup_delay", translate("Startup Delay"))
o:value(0, translate("Not enabled"))
for _, v in ipairs({5, 10, 15, 25, 40, 60, 120}) do
	o:value(v, translate("%u seconds") %{v})
end
o.datatype = "uinteger"
o.default = 0
o.rmempty = false

o = s:option(DynamicList, "lan_bp_list", translate("ByPass LAN"), translate("e.g. 192.168.1.100"))
luci.ip.neighbors({family = 4}, function(neighbor)
	if neighbor.reachable then
		o:value(neighbor.dest:string(), "%s (%s)" %{neighbor.dest:string(), neighbor.mac})
	end
end)
o.placeholder = "8.8.8.8:53"
o.datatype    = 'network'
o.rmempty     = false

return m
