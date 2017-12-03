import React from 'react';

// stateless conponenet
export default function Accounts({
    accounts = [],
    onSelectAccount
}) {
    return (
        <div className="pure-menu siderbar">
            <span className="pure-menu-heading"> </span>
            <ul className="pure-menu-heading"></ul>

            <ul className="pure-menu-list">
            { accounts.map(account => (
                <li className="pure-menu-item" key={acount} onClick={onSelectAccount}>
                    <a href="#" className="pure-menu-link">{account}</a>
                </li>
            ))}
            </ul>
        </div>
    )
}