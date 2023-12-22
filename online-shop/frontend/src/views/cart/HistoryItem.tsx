import { Card, CardBody } from "react-bootstrap";

export type HistoryItem =  { productName: string, quantity: number, price: number };

type Props = {
    historyItems: HistoryItem[];
}

export default function ShowHistoryItem(props: Props) {
    return <Card>
        <CardBody>
            <Card.Title>
                Your order
            </Card.Title>
            <Card.Text>
                {props.historyItems.map(item => {
                    return <div>
                        {item.productName}<br/>
                        Quantity: {item.quantity}<br/>
                        Price: {item.price * item.quantity}
                    </div>
                })}
            </Card.Text>
        </CardBody>
    </Card>;
}