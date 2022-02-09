window.vis = require('vis-network/standalone');
//var container = document.getElementById('bot-graph');
var nodes = new vis.DataSet([
  {id: 1, label: 'Node 1'},
  {id: 2, label: 'Node 2'},
  {id: 3, label: 'Node 3'},
  {id: 4, label: 'Node 4'},
  {id: 5, label: 'Node 5'}
]);

// create an array with edges
var edges = new vis.DataSet([
  {from: 1, to: 3},
  {from: 1, to: 2},
  {from: 2, to: 4},
  {from: 2, to: 5}
]);


// provide the data in the vis format
var data = {
  nodes: nodes,
  edges: edges
};

document.addEventListener('DOMContentLoaded', function() {
  var container = jQuery('#bot-graph')[0];
  var network = new vis.Network(container, data, {});
});
