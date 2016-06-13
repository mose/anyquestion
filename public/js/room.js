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
    var messages = this.state.messages.map(function (message) {
      console.log(message);
      // "question that is asked::::15687231,34257681,432675"
      var parts = message.split("::::");
      var question = parts[0];
      var votes = parts[1].split(",");
      if (votes.indexOf(user) > -1) {
        return React.createElement("li", null,
          React.createElement('span', { style: {color: color} }, votes.length),
          React.createElement('span', null, question.trim())
        );
      } else {
        return React.createElement("li", null,
          React.createElement('span', { style: {color: color} }, votes.length),
          React.createElement('span', null, question.trim())
        );
      }
    });

    return React.createElement("div", null,
      React.createElement("input", { autofocus: true, placeholder: "What is your question?", type: "text", ref: "message", onKeyUp: this.sendQuestionWithEnter }),
      React.createElement("button", { type: "button", onClick: this.sendQuestion }, "Ask"),
      React.createElement("ul", null, messages)
    ); 
  }

});

ReactDOM.render(React.createElement(Room, null), document.getElementById('room'));
