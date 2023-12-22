import axios from "axios";

const API_PATH = 'http://localhost:3000';

export type ShoppingItem = {
    id: string,
    name: string,
    price: number,
    category: string
};

export async function getItemList(name?: string, category?: string): Promise<ShoppingItem[]> {
    let url = `${API_PATH}/api/items?`;
    if (name) {
        url += `&name=${name}`;
    }
    if (category && category !== 'All') {
        url += `&category=${category}`;
    }
    return (await axios.get(url)).data as ShoppingItem[];
}

export async function getCategories(): Promise<string[]> {
    return (await axios.get(`${API_PATH}/api/categories`)).data as string[];
}

export async function getHistory(username: string): Promise<any[]> {
    return (await axios.get(`${API_PATH}/api/history?username=${username}`)).data as any[];
}

export async function buyItems(username: string, order: any): Promise<void> {
    return (await axios.post(`${API_PATH}/api/buy`, { username, order })).data as void;
}