import { useDebounceFn } from '@ant-design/pro-components';
import { AutoComplete } from 'antd';
import { Namespace } from 'kubernetes-types/core/v1';
import { FormattedMessage } from 'umi';

export const QueryItem = (
    namespaces: Namespace[],
    query: () => Promise<void>,
) => {
    const { run: debouncedQuery } = useDebounceFn(query, 500);
    const placeholer = <FormattedMessage id="pleaseEnter" />;
    return {
        title: <FormattedMessage id="namespace" />,
        key: 'searchNamespace',
        dataIndex: ['metadata', 'name'],
        hideInTable: true,
        renderFormItem: () => {
            return (
                <AutoComplete
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
};

// export default queryItem
