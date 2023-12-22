import { useEffect, useState } from 'react';
import './App.css'
import 'bootstrap/dist/css/bootstrap.min.css';
import ItemListView from './views/itemList/ItemsList';
import { ShoppingItem, getItemList } from './services/shop';
import ItemSearch from './views/itemSearch/ItemSearch';
import Cart from './views/cart/Cart';

export type ProductInCart = {
  product: ShoppingItem;
  quantity: number;
};

function App() {
  const [itemList, setItemList] = useState<ShoppingItem[]>([]);
  const [showCart, setShowCart] = useState<boolean>(false);
  const [userCart, setUserCart] = useState<ProductInCart[]>([]);

  useEffect(() => {
      getItemList()
          .then(data => {
              setItemList(data);
          })
          .catch(() => console.log('error while fetching data'));
  }, []);

  return (
    <>
      <h1>Best shop in the world</h1>
      {!showCart && <>
        <ItemSearch setItemListCallback={setItemList} showCart={() => setShowCart(true)}/>
        <div className="card">
        <ItemListView userCart={userCart} itemList={itemList} updateUserCart={setUserCart}/>
      </div></>}
      {showCart && <Cart closeCart={() => setShowCart(false)} userCart={userCart} setUserCart={setUserCart}/>}
    </>
  )
}

export default App;
