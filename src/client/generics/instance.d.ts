interface instance {
	getChildrenOfClass: (inst: Instance, ...names: string[]) => Instance[];
	getDescendantsOfClass: (inst: Instance, ...names: string[]) => Instance[];
	getChildrenWhichIsA: (inst: Instance, ...names: string[]) => Instance[];
	getDescendantsWhichIsA: (inst: Instance, ...names: string[]) => Instance[];
	getChildrenOfConditions: (inst: Instance, fn: (i: instance) => boolean) => Instance[];
	getDescendantsOfConditions: (inst: Instance, fn: (i: instance) => boolean) => Instance[];
	findFirstChildOfConditions: (inst: Instance, fn: (i: instance) => boolean) => Instance | undefined;
	findFirstDescendantOfConditions: (inst: Instance, fn: (i: instance) => boolean) => Instance | undefined;
}

declare const instance: instance;

export = instance;
