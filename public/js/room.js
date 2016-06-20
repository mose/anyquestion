Array.prototype.contains = function(obj) {
  let i = this.length;
  while (i--) {
    if (this[i] === obj) {
      return true;
    }
  }
  return false;
}

const User = function(){
  let user = parseInt(localStorage.getItem('aq_userid')) || Math.floor((Math.random() * 100000000) + 1);
  localStorage.setItem('aq_userid', user);
  return user;
}

const Server = function(){
  const ws_protocol = location.protocol == "https:" ? 'wss' : 'ws';
  return new WebSocket(`${ws_protocol}://${location.hostname}:${location.port}/ws?room=${location.pathname.split('/').reverse()[0]}`);
}

class Room extends React.Component {
  constructor(props){
    super(props);
    this.state ={
      question: '',
      questions: []
    }
  }

  componentDidMount() {
    this.sendable = true;
    const self = this;
    let server, user, questions;

    server = Server();
    user = User();

    server.onmessage = event => {
      questions = JSON.parse(event.data);
      self.setState({questions});
      self.refs.question.focus();
    };

    server.onopen = () => {
      server.send("hi");
    };

    server.onclose = () => {
      server.send("bye");
    };

    this.props.server = server;
    this.props.user = user;

    this.refs.question.focus();
  }

  componentWillUnmount() {
    window.removeEventListener("unload");
  }

  sendQuestion() {
    const self = this;
    if (!this.sendable || this.refs.question.value === "") {
      return false;
    }

    setTimeout(() => {
      self.sendable = true;
    }, 100);

    this.props.server.send(`${this.props.user}::::${this.refs.question.value}`);

    this.refs.question.value = '';
    this.sendable = false;
  }

  sendVote(qid) {
    this.props.server.send(`${qid}----${this.props.user}`);
  }

  sendQuestionWithEnter(e) {
    if (e.keyCode == 13) {
     this.sendQuestion();
    }
  }

  render() {
    var user = this.props.user;
    var server = this.props.server;

    const questions = this.state.questions.map(q => React.createElement("li", null,
      React.createElement('span', { className: (q.voters.contains(user) ? "voted" : "votable"), onClick: this.sendVote.bind(this, q.id) }, q.voters.length),
      React.createElement('span', { className: "q" }, q.name)
    ));

    return React.createElement("div", { className: "questions" },
      React.createElement("input", { autofocus: true, placeholder: "What is your question?", type: "text", ref: "question", onKeyUp: this.sendQuestionWithEnter.bind(this) }),
      React.createElement("ul", null, questions)
    );
  }
}


ReactDOM.render(React.createElement(Room, null), document.getElementById('room'));
