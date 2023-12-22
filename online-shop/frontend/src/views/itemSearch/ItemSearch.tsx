import './ItemSearch.css';
import { useEffect, useState } from "react";
import { ShoppingItem, getCategories, getItemList } from "../../services/shop";
import { Button, Dropdown, DropdownButton } from "react-bootstrap";

type Props = {
    setItemListCallback: (newItemList: ShoppingItem[]) => void;
    showCart: () => void;
}

export default function ItemSearch({ setItemListCallback, showCart }: Props) {
    const [selectedCategory, setSelectedCategory] = useState<string>('All');
    const [itemName, setItemName] = useState<string>('');

    const [categories, setCategories] = useState<string[]>([]);

    useEffect(() => {
        getCategories()
            .then(setCategories);
    }, []);

    const searchList = () => {
        getItemList(itemName, selectedCategory)
            .then(setItemListCallback);
    };

    return (
        <div className='contentBox'>
            <input onChange={event => setItemName(event.target.value)} placeholder='Search item'/>
            <Dropdown>
                <DropdownButton title={selectedCategory}>
                    {categories.map(category => {
                        return <Dropdown.Item key={category} onClick={() => setSelectedCategory(category)}>{category}</Dropdown.Item>
                    })}
                </DropdownButton>
            </Dropdown>
            <Button onClick={searchList}>Search</Button>
            <Button onClick={showCart}>Your cart</Button>
        </div>
    )
}