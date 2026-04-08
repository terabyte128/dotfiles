local M = {}

function M.add_work_rules(config)
	table.insert(config.hyperlink_rules, {
		regex = [[([A-Z]{2,4})-(\d+)]],
		format = "https://jira.i.extrahop.com/browse/$1-$2",
	})
end

return M
