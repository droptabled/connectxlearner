import React from 'react'
import PropTypes from 'prop-types'
import React, { useState, useEffect } from 'react'
import BotPlayChannel from 'channels/bot_play_channel'

function Cell(props) {
  return(
    <td className={"cell-" + props.value}></td>
  )
}

function CellRow(props) {
  return(
    <tr className="cell-row">
      {
        props.cells.map((cell, i) => {
          return <Cell key={i} value={cell}/>
        })
      }
    </tr>
  )
}

function EventTransmitter() {
  const [nextBotMoveColumn, setNextBotMoveColumn] = useState(0)
  const [moves, setMoves] = useState([])

  useEffect(() => { 
    MessagesChannel.received = (data) => setMessages(data.messages)
  }, [])
}

class Board extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cells: Array.from(Array(props.rows), () => new Array(props.cols).fill(null)),
    };
  }

  render() {
    const status = 'Next player: X';

    return (
      <div>
        <div className="status">Board Status</div>
        <table className="game">
          <tbody>
          {
            this.state.cells.map((row, i) => {
              return <CellRow key={i} cells={row} />
            })
          }
          </tbody>
        </table>
      </div>
    );
  }
}

export default class Game extends React.Component {
  render() {
    return (
      <div className="game">
          <Board rows={this.props.rows} cols={this.props.cols}/>
        <div className="game-info">
          <div>{/* status */}</div>
          <ol>{/* TODO */}</ol>
        </div>
      </div>
    );
  }
}

Game.propTypes = {
  rows: PropTypes.number,
  cols: PropTypes.number,
  bot_id: PropTypes.number,
  cable: PropTypes.object
}