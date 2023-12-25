/*
 Copyright 2023 Juicedata Inc

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package dashboard

import (
	"github.com/gin-gonic/gin"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/klog"
)

type ListNamespaceResult struct {
	Total int                 `json:"total"`
	NSs   []*corev1.Namespace `json:"nss"`
}

// func (api *API) ListNamespace() gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		// namespaces := make([]*corev1.Namespace, 0)
// 		namespaceList := make([]string, 0)
// 		namespaces, err := api.client.CoreV1().Namespaces().List(context.TODO(), metav1.ListOptions{})
// 		if err != nil {
// 			c.String(500, "get namespace error %v", err)
// 			return
// 		}
// 		for _, namespace := range namespaces.Items {
// 			namespaceList = append(namespaceList, namespace.Name)
// 		}
// 		// klog.V(0).Infof("namespace list-- is %s\n", namespaceList)
// 		ListNamespaceResult := &ListNamespaceResult{
// 			Total:      len(namespaces.Items),
// 			Namespaces: namespaceList,
// 		}
// 		c.IndentedJSON(200, ListNamespaceResult)
// 	}
// }

func (api *API) listNSsHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		nsList := corev1.NamespaceList{}
		err := api.cachedReader.List(c, &nsList)
		if err != nil {
			c.String(500, "get namespace error: %v", err)
			return
		}
		klog.V(0).Infof("namespace-- is %s\n", &nsList.Items[0])
		var nss []*corev1.Namespace
		for i := range nsList.Items {
			ns := &nsList.Items[i]
			nss = append(nss, ns)
		}
		c.IndentedJSON(200, nss)
	}
}
