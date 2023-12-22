import { Button, Card } from "react-bootstrap"
import { ShoppingItem } from "../../services/shop"
import { ProductInCart } from "../../App";

type Props = {
    product: ShoppingItem;
    userCart: ProductInCart[];
    updateUserCart: (newCart: ProductInCart[]) => void;
}

export default function ItemView({ product, userCart, updateUserCart }: Props) {
    const addToCart = () => {
        const newUserCart = [...userCart];
        let found = false;
        for (let i=0; i<newUserCart.length; i++) {
            if (newUserCart[i].product.id === product.id) {
                found = true;
                newUserCart[i].quantity++;
                break;
            }
        }
        if (!found) {
            newUserCart.push({ product, quantity: 1 });
        }
        updateUserCart(newUserCart);
    };

    return (<Card>
        <Card.Body>
         <Card.Title>{product.name}</Card.Title>
        <Card.Text>Price: {product.price}</Card.Text>
        <Button onClick={addToCart}>Add to cart</Button>
        </Card.Body>
    </Card>);
}