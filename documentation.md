# API Documentation

## Users

### Register User
**Endpoint:** `POST /api/v1/register`

**Description:** Registers a new user.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"first_name": "<First Name>", "last_name": "<Last Name>", "email": "<Email>", "pin": "<Pin>"}' \
  http://localhost:3000/api/v1/register -i
```

**Example Response:**
```json
{
  "message": "Usuario registrado exitosamente",
  "token": "<JWT Token>",
  "user": {
    "id": <id>,
    "first_name": "<First Name>",
    "last_name": "<Last Nam>e",
    "email": "<Email>"
  },
  "account": {
    "account_number": "<Account number>",
    "balance": <Balance>
  }
}
```

### Login User
**Endpoint:** `POST /api/v1/login`

**Description:** Logs in a user.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"account_number": "<Integer>", "pin": "<PIN>"}' \
  http://localhost:3000/api/v1/login -i
```

### Update User
**Endpoint:** `PUT /api/v1/users/<id>/`

**Description:** Logs in a user.

**Request:**
```bash
curl -X PUT \
  -H "Content-Type: application/json" \
  -d '{"first_name": "<First Name>", "last_name": "<Last Name>", "email": "<Email>"}' \
  http://localhost:3000//api/v1/users/<id>/ -i
```

---

## Accounts

### Get All Accounts
**Endpoint:** `GET /api/v1/accounts`

**Description:** Retrieves all accounts for the authenticated user.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/accounts -i
```

**Example Response:**
```json
[
  {
    "id": <id>,
    "user_id": <id>,
    "account_number": "<Numer>",
    "clabe": "<CLABE>",
    "balance": <Balance>
  },
]
```

### Create New Account
**Endpoint:** `POST /api/v1/accounts`

**Description:** Creates a new account for the authenticated user.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/accounts/ -i
```

**Example Response:**
```json
{
  "id": 9,
  "user_id": 3,
  "account_number": "<Account Number>",
  "balance": 0,
  "clabe": "<Clabe>",
  "created_at": "<Created At>",
  "updated_at": "<Updated At>",
  "default": false,
  "account_type": "user"
}
```

### Get Account Details
**Endpoint:** `GET /api/v1/accounts/{account_id}`

**Description:** Retrieves details of a specific account.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/accounts/1 -i
```

**Example Response:**
```json
{
  "id": <id>,
  "user_id": <id>,
  "account_number": "<Account Number>",
  "balance": <Balance>,
  "clabe": "<CLABE>",
  "created_at": "<Created at>",
  "updated_at": "<Updated at>",
  "default": <Bool>,
  "account_type": "user"
}
```

---

## Recipients

### Create Recipient
**Endpoint:** `POST /api/v1/recipients`

**Description:** Adds a recipient for fund transfers.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  -d '{ "recipient": {"clabe": "<CLABE>", "name": "<Name>"} }' \
  http://localhost:3000/api/v1/recipients/ -i
```

**Example Response:**
```json
{
  "id": <id>,
  "user_id": <id>,
  "name": "<Name>",
  "account_id": <id>,
  "created_at": "<Created at>",
  "updated_at": "<Updated at>"
}
```

### Get All Recipients
**Endpoint:** `GET /api/v1/recipients`

**Description:** Retrieves all recipients for the authenticated user.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/recipients/ -i
```

**Example Response:**
```json
[
  {"id": <id>, "name": "<Name>", "account_id": <id>}
]
```

---

## Services

### Get Services
**Endpoint:** `GET /api/v1/services`

**Description:** Retrieves all available services.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/services/ -i
```

---

## Transactions

### Get Account Transactions
**Endpoint:** `GET /api/v1/accounts/{account_id}/transactions`

**Description:** Retrieves all transactions for a specific account.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://localhost:3000/api/v1/accounts/2/transactions -i
```

### Create Transaction
**Endpoint:** `POST /api/v1/accounts/{account_id}/transactions`

**Description:** Creates a new transaction.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  -d '{"recipient_account_id": <id>, "amount": <Amount>, "description": "Transferencia"}' \
  http://localhost:3000/api/v1/accounts/2/transactions -i
```

**Example Response:**
```json
{
  "message": "Transferencia realizada con éxito",
  "amount": <Amount>,
  "source_account": {
    "account_number": "<Account number>"
  },
  "recipient_account": {
    "account_number": "<Account number>"
  }
}
```

---

## Pay Service

**Endpoint:** `POST /api/v1/accounts/{account_id}/pay_service`

**Description:** Pays for a service using a specific account.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  -d '{"service_id": <id>, "amount": <Amount>, "description": "<Description>"}' \
  http://localhost:3000/api/v1/accounts/1/pay_service -i
