import React from "react";

class ErrorBoundaryWithRetry extends React.Component {
  constructor(props) {
    super(props);
    this.state = { error: null, fetchKey: 0 };
    this._retry = this._retry.bind(this);
  }

  static getDerivedStateFromError(error) {
    return { error, fetchKey: 0 };
  }

  _retry() {
    this.setState((prevState) => ({
      error: null,
      fetchKey: prevState.fetchKey + 1,
    }));
  }

  render() {
    const { children, fallback } = this.props;
    const { error, fetchKey } = this.state;
    if (error) {
      return typeof fallback === "function"
        ? fallback({ error, fetchKey, retry: this._retry })
        : fallback;
    }
    return children({ fetchKey });
  }
}

export default ErrorBoundaryWithRetry;
