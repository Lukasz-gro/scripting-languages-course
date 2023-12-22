import { ProductInCart } from "../../App";
import { ShoppingItem } from "../../services/shop";
import ItemView from "./ItemView";

type Props = {
    itemList: ShoppingItem[];
    userCart: ProductInCart[];
    updateUserCart: (newCart: ProductInCart[]) => void;
}

export default function ItemListView({ itemList, userCart, updateUserCart }: Props) {
    return (<>
        {itemList.map((item) => {
            return <ItemView key={item.id} product={item} userCart={userCart} updateUserCart={updateUserCart} />
        })}
    </>);
}