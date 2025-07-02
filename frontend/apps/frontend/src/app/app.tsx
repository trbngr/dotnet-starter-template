// Uncomment this line to use CSS modules
// import styles from './app.module.css';
import { useAuth } from 'react-oidc-context';

import { Route, Routes, Link } from 'react-router-dom';

export function App() {
  const auth = useAuth();

  return (
    <div>

      <div className="wrapper">
        <div className="container">
          <div id="welcome">
            <h1>
              <span> Hello there, </span>
              Welcome {auth.user?.profile.name!} 👋
              <br />
              <button onClick={() => auth.signoutRedirect()}>
                Sign Out
              </button>
            </h1>
          </div>
        </div>
      </div>

      {/* START: routes */}
      {/* These routes and navigation have been generated for you */}
      {/* Feel free to move and update them to fit your needs */}
      <br />
      <hr />
      <br />
      <div role="navigation">
        <ul>
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/page-2">Page 2</Link>
          </li>
        </ul>
      </div>
      <Routes>
        <Route
          path="/"
          element={
            <div>
              This is the generated root route.{' '}
              <Link to="/page-2">Click here for page 2.</Link>
            </div>
          }
        />
        <Route
          path="/page-2"
          element={
            <div>
              <Link to="/">Click here to go back to root page.</Link>
            </div>
          }
        />
      </Routes>
      {/* END: routes */}
    </div>
  );
}

export default App;
