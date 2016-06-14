var Room = React.createClass({

  getInitialState: function () {
    return {
      message: '',
      messages: []
    };
  },

  componentDidMount: function () {
    var self = this;
    this.sendable = true;
    var server = new WebSocket("ws://" + location.hostname + ":" + location.port + "/ws?room=" + location.pathname.split('/').reverse()[0]);
    var user = localStorage.getItem('aq_userid') || Math.floor((Math.random() * 100000000) + 1);
    localStorage.setItem('aq_userid', user);
    server.onmessage = function (event) {
      console.log(event.data);
      var messages = JSON.parse(event.data);
      self.setState({messages: messages});
      self.refs.message.focus();
    };

    // server.onopen = function () {
    //   server.send(user + ": joined the room.");
    // };

    // server.onclose = function () {
    //   server.send(user + ": left the room.");
    // };

    this.server = server;
    this.user = user;
    this.refs.message.focus();
  },

  sendQuestion: function () {
    if (!this.sendable) {
      return false;
    }
    var self = this;
    setTimeout(function () {
      self.sendable = true; 
    }, 100);
    this.server.send(this.user + "::::" + this.refs.message.value);
    this.refs.message.value = '';
    this.sendable = false;
  },

  sendQuestionWithEnter: function (e) {
    if (e.keyCode == 13) {
     this.sendQuestion(); 
    }
  },

  render: function () {
    var messages = this.state.messages.map(function (q) {
      console.log(q);
      if (q.voters.indexOf(this.user) > -1) {
        return React.createElement("li", null,
          React.createElement('span', { className: "votable" }, q.voters.length),
          React.createElement('span', null, q.name)
        );
      } else {
        return React.createElement("li", null,
          React.createElement('span', { className: "voted" }, q.voters.length),
          React.createElement('span', null, q.name)
        );
      }
    });

    return React.createElement("div", { className: "questions" },
      React.createElement("input", { autofocus: true, placeholder: "What is your question?", type: "text", ref: "message", onKeyUp: this.sendQuestionWithEnter }),
      React.createElement("ul", null, messages)
    ); 
  }

});

ReactDOM.render(React.createElement(Room, null), document.getElementById('room'));
