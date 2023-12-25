import { host } from '@/services/common';
import { Namespace } from 'kubernetes-types/core/v1';

export const listNamespace = async () => {
    let data: Namespace[] = [];
    try {
        const rawNS = await fetch(`${host}/api/v1/namespaces`);
        data = JSON.parse(await rawNS.text());
        console.log(data);
    } catch (e) {
        console.log('fail to list ns');
        return { data: [], success: false };
    }
    return {
        data,
        success: true,
    };
};
