Array.prototype.contains = function(obj) {
  var i = this.length;
  while (i--) {
    if (this[i] === obj) {
      return true;
    }
  }
  return false;
}

var Room = React.createClass({

  getInitialState: function () {
    return {
      question: '',
      questions: []
    };
  },

  componentDidMount: function () {
    var self = this;
    this.sendable = true;
    var server = new WebSocket("ws://" + location.hostname + ":" + location.port + "/ws?room=" + location.pathname.split('/').reverse()[0]);
    var user = parseInt(localStorage.getItem('aq_userid')) || Math.floor((Math.random() * 100000000) + 1);
    localStorage.setItem('aq_userid', user);
    server.onmessage = function (event) {
      // console.log(event.data);
      var questions = JSON.parse(event.data);
      self.setState({questions: questions});
      self.refs.question.focus();
    };
    this.server = server;
    this.user = user;
    this.refs.question.focus();
  },

  sendQuestion: function () {
    if (!this.sendable) {
      return false;
    }
    var self = this;
    setTimeout(function () {
      self.sendable = true; 
    }, 100);
    this.server.send(this.user + "::::" + this.refs.question.value);
    this.refs.question.value = '';
    this.sendable = false;
  },

  sendVote: function (qid) {
    this.server.send(qid + "----" + this.user);
  },

  sendQuestionWithEnter: function (e) {
    if (e.keyCode == 13) {
     this.sendQuestion(); 
    }
  },

  render: function () {
    var self = this;
    var user = this.user;
    var questions = this.state.questions.map(function (q) {
      if (q.voters.contains(user)) {
        return React.createElement("li", null,
          React.createElement('span', { className: "voted" }, q.voters.length),
          React.createElement('span', { className: "q" }, q.name)
        );
      } else {
        return React.createElement("li", null,
          React.createElement('span', { className: "votable", onClick: self.sendVote.bind(null, q.id) }, q.voters.length),
          React.createElement('span', { className: "q" }, q.name)
        );
      }
    });

    return React.createElement("div", { className: "questions" },
      React.createElement("input", { autofocus: true, placeholder: "What is your question?", type: "text", ref: "question", onKeyUp: this.sendQuestionWithEnter }),
      React.createElement("ul", null, questions)
    ); 
  }

});

ReactDOM.render(React.createElement(Room, null), document.getElementById('room'));
