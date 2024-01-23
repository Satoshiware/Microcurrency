// Copyright (c) 2011-2020 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef MICROCURRENCY_QT_MICROCURRENCYADDRESSVALIDATOR_H
#define MICROCURRENCY_QT_MICROCURRENCYADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class MicrocurrencyAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit MicrocurrencyAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

/** Microcurrency address widget validator, checks for a valid microcurrency address.
 */
class MicrocurrencyAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit MicrocurrencyAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

#endif // MICROCURRENCY_QT_MICROCURRENCYADDRESSVALIDATOR_H
