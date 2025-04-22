--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Module
local pages = {}


--[[ Functions: 

	pages.listAllItems(page)
	pages.listItemsInPage(page, pageNumber)
	pages.getNumberOfPages(page)

]]


--[[ pages.listAllItems(page)
	PARAMETERS: 
	- <Pages> page: The Page object to navigate.

	RETURNS:
	- <table> result: A dictionary of all items in the Page.

	Returns a dictionary of all items within the given Page. ]] 
function pages.listAllItems(page: Pages): { [string]: any }
	local result = {}
	
	while page.IsFinished == false do
		for _, entry in page:GetCurrentPage() do
			result[entry.key] = entry.value
		end
		
		if page.IsFinished == false then page:AdvanceToNextPageAsync() end
	end
	
	return result
end


--[[ pages.listItemsInPage(page)
	PARAMETERS: 
	- <Pages> page: The Page object to navigate.

	RETURNS:
	- <table> result: The items in the given page number in a Page.

	Returns the items in the given page number. ]] 
function pages.listItemsInPage(page: Pages, pageNumber: number): { [string]: any }
	local currentPage = 0
	local result = {} :: { [string]: any }

	while page.IsFinished == false do
		if currentPage ~= pageNumber then
			currentPage += 1
			page:AdvanceToNextPageAsync()

		elseif currentPage == pageNumber then
			for key, value in page:GetCurrentPage() do
				result[tostring(key)] = value
			end
			
		end
	end
	
	return result
end


--[[ pages.getNumberOfPages(page)
	PARAMETERS: 
	- <Pages> page: The Page object to navigate.

	RETURNS:
	- <table> num: The number of pages in the Pages object.

	Returns the number of pages in the given Page. ]] 
function pages.getNumberOfPages(page: Pages): number
	local num = 0

	while page.IsFinished == false do
		num += 1
		page:AdvanceToNextPageAsync()
	end

	return num
end


return pages