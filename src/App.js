import React from 'react';
import { ChakraProvider } from "@chakra-ui/react";
import Game from './Game';
import './App.css';

function App() {
  return (
    <ChakraProvider>
      <div className="App">
        <Game />
      </div>
    </ChakraProvider>
  );
}

export default App;
