import './Cart.css'
import { Button } from "react-bootstrap";
import { ProductInCart } from "../../App";
import { useEffect, useState } from "react";
import ItemInCart from "./ItemInCart";
import { buyItems, getHistory } from '../../services/shop';
import ShowHistoryItem, { HistoryItem } from './HistoryItem';

type Props = {
  userCart: ProductInCart[];
  setUserCart: (newCart:  ProductInCart[]) => void;
  closeCart: () => void;
};

export default function Cart({ userCart, closeCart, setUserCart }: Props) {
    const [username, setUsername] = useState<string>('');
    const [showHistory, setShowHistory] = useState<boolean>(false);
    const [history, setHistory] = useState<Map<number, HistoryItem[]>>(new Map());

    const onBuyAction = () => {
        buyItems(username, userCart).then(() => {
            setUserCart([]);
        });
    };

    const onDownloadHistory = () => {
        getHistory(username).then(res => {
            const orderMap = new Map<number, HistoryItem[]>();
            res.forEach(item => {
                const orderId = item.orderId as number;
                if (!orderMap.has(orderId)) {
                    orderMap.set(orderId, []);
                }
                const curr = orderMap.get(orderId) || [];
                orderMap.set(orderId, [...curr, { productName: item.productName, quantity: item.quantity, price: item.price }]);
            });
            console.log(orderMap);
            setHistory(orderMap);
        });
    };

    useEffect(() => {
        if (showHistory) {
            onDownloadHistory();
        } else {
            setHistory(new Map());
        }
    }, [showHistory]);

    return <div>
        <div className='contentBox'>
            <input onChange={event => setUsername(event.target.value)} placeholder='Enter your name'/>
            <Button disabled={userCart.length === 0} onClick={onBuyAction}>Buy</Button>
            <Button onClick={() => setShowHistory(!showHistory)}>{showHistory ? 'Cart' : 'History'}</Button>
            <Button onClick={closeCart}>Close cart</Button>
        </div>
        {(showHistory && history.size > 0) && <div>
            <h2>Your history:</h2>
            {Array.from(history.entries()).map((key, value) => {
                return <ShowHistoryItem key={key[0].toString()} historyItems={key[1]} />;
            })}
        </div>}
        {(showHistory && history.size === 0) && <div>No history for this user</div>}
        {(!showHistory && userCart.length > 0) && 
            <div>
                <h2>Your order:</h2>
                {userCart.map(item => <ItemInCart key={item.product.id} productInCart={item} userCart={userCart} updateCart={setUserCart}/>)}
            </div>}
        {(!showHistory && userCart.length === 0) && <div>Your cart is empty</div>}
    </div>;
}