interface security {
	generateRandomID: () => string;
}

declare const pages: security;

export = security;
