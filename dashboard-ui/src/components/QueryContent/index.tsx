import { listNamespace } from '@/services/namespace';
import { useDebounceFn } from '@ant-design/pro-components';
import { AutoComplete } from 'antd';
import { Namespace } from 'kubernetes-types/core/v1';
import { useEffect, useState } from 'react';
import { FormattedMessage } from 'umi';

function QueryItem() {
    const [namespaces, setNamespaces] = useState<Namespace[]>([]);
    const queryNamespaces = async () => {
        const { data, success } = await listNamespace();
        if (success) {
            setNamespaces(data);
        }
    };
    const { run: debouncedQuery } = useDebounceFn(queryNamespaces, 500);
    const placeholer = <FormattedMessage id="pleaseEnter" />;
    useEffect(() => {
        queryNamespaces();
    }, []);

    return {
        title: <FormattedMessage id="namespace" />,
        key: 'searchNamespace',
        hideInTable: true,
        valueType: Text,
        renderFormItem: () => {
            return (
                <AutoComplete
                    backfill={true}
                    autoFocus={true}
                    options={namespaces.map((ns) => ({
                        value: ns.metadata?.name,
                    }))}
                    placeholder={placeholer}
                    filterOption={(inputValue, option) =>
                        option?.value
                            ?.toLowerCase()
                            .indexOf(inputValue.toLowerCase()) !== -1
                    }
                    onChange={debouncedQuery}
                />
            );
        },
    };
}

export default QueryItem;
