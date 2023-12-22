import { Button, Card, CardBody, CardText, CardTitle } from "react-bootstrap";
import { ProductInCart } from "../../App"

type Props = {
    productInCart: ProductInCart;
    userCart: ProductInCart[];
    updateCart: (newCart: ProductInCart[]) => void;
}

export default function ItemInCart({ productInCart, userCart, updateCart }: Props) {
    const changeCart = (val: number) => {
        const newUserCart= [...userCart];
        for (let i=0; i<newUserCart.length; i++) {
            if (newUserCart[i].product.id === productInCart.product.id) {
                newUserCart[i].quantity += val;
                break;
            }
        }
        const res = newUserCart.filter(item => item.quantity !== 0);
        updateCart(res);
    };

    return <Card>
        <CardBody>
            <CardTitle> Name: {productInCart.product.name}</CardTitle>
            <CardText>
                Quantity: <Button onClick={() => changeCart(-1)}>-</Button>{productInCart.quantity}<Button onClick={() => changeCart(1)}>+</Button>
            </CardText>
            <CardText>
                Total price: {productInCart.product.price * productInCart.quantity}
            </CardText>
        </CardBody>
    </Card>
}