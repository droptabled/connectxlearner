import React from 'react'
import ReactDOM from 'react-dom/client'

class Cell extends React.Component {

}

class Board extends React.Component {

}

class Game extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      squares: Array(9).fill(null),
      playerIsNext: true
    };
  }

  render() {
    return(
      <div>
        Playing against Bot
        <div>
          { this.state.playerIsNext ? "Your Turn" : "Bot Thinking..." }
        </div>
        <Board />
      </div>
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const root = ReactDOM.createRoot(document.getElementById("root"));
  root.render(<Game />);
})