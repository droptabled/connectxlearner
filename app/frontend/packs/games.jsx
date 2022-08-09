import React from 'react'
import ReactDOM from 'react-dom/client'

class Cell extends React.Component {
  render() {
    return(
      <button className="cell" onClick={props.onClick}>
        {props.value}
      </button>
    )
  }
}

class Board extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cells: Array.from(Array(props.rows), () => new Array(props.cols).fill(null)),
      playerIsNext: true,
    };
  }


  render() {
    <div>
      <div className="status">TODO: Add status</div>
      {this.state.cells.map((row, i) =>
        <div className="cell-row" key={i}></div>
      )}
    </div>
  }
}

class Game extends React.Component {
  render() {
    return(
      <div>
        <div>Title</div>
        <Board rows={7} cols={8} />
      </div>
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const root = ReactDOM.createRoot(document.getElementById("root"));
  root.render(<Game />);
})