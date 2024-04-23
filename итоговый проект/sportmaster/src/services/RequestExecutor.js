const INIT = {
    headers: {
        "Content-Type": "application/json;charset=utf-8"
    }
};
import { useStore } from '../store';
class RequestExecutor {
    constructor() {
        this.baseUrl = "api/rest/kubsu_study/web_data_api/";
    }

    async execute(url, exact = false, init = {}, data = null) {
        const loadingStore = useStore();
        loadingStore.setIsLoading(true);
        try {
            if (data) {
                init.body = JSON.stringify(data);
            }
            const fullUrl = exact ? url : `${this.baseUrl}${url}`;
            const response = await fetch(fullUrl, {...INIT, ...init});
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            loadingStore.setIsLoading(false);
            console.log(data)
            return await response.json();
        } catch (error) {
            console.error("Request failed:", error);
            throw error;
        } finally {
            loadingStore.setIsLoading(false);
        }
    }

    get(url, code = null) {
        return this.execute(code ? `${url}/${code}` : url, false, { method: "GET" });
    }

    post(url, data) {
        return this.execute(url, false, { method: "POST" }, data);
    }

    put(url, code, data) {
        return this.execute(`${url}/${code}`, false, { method: "PUT" }, data);
    }

    delete(url, code) {
        return this.execute(`${url}/${code}`, false, { method: "DELETE" });
    }
}

export default new RequestExecutor();