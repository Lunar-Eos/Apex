interface pages {
	listAllItems: (page: Pages) => never[];
	listItemsInPage: (page: Pages, pageNumber: number) => never[];
	getNumberOfPages: (page: Pages) => number;
}

declare const pages: pages;

export = pages;
