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
    "id": 4,
    "first_name": "<First Name>",
    "last_name": "<Last Nam>e",
    "email": "<Emai.>"
  },
  "account": {
    "account_number": "<Account number>",
    "balance": 1000
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
  -d '{"email": "Userv2@example.com", "pin": "1234"}' \
  http://localhost:3000/api/v1/login -i
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
    "id": <Id>,
    "user_id": <Id>,
    "account_number": "<Numer>",
    "clabe": "<CLABE>",
    "balance": 1000
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
  "account_number": "9265363267",
  "balance": 0,
  "clabe": "104325113235609394",
  "created_at": "2024-12-16T21:02:49.117Z",
  "updated_at": "2024-12-16T21:02:49.117Z",
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
  "id": 8,
  "user_id": 3,
  "account_number": "2687243901",
  "balance": 0,
  "clabe": "138931635507595959",
  "created_at": "2024-12-16T21:01:24.660Z",
  "updated_at": "2024-12-16T21:01:24.660Z",
  "default": false,
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
  -d '{ "recipient": {"clabe": "104325113235609394", "name": "Example"} }' \
  http://localhost:3000/api/v1/recipients/ -i
```

**Example Response:**
```json
{
  "id": 3,
  "user_id": 2,
  "name": "Eduardo Isamel",
  "account_id": 9,
  "created_at": "2024-12-16T21:03:22.970Z",
  "updated_at": "2024-12-16T21:03:22.970Z"
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
  {"id": 1, "name": null, "account_id": 2},
  {"id": 2, "name": "User1 Mine", "account_id": 4},
  {"id": 3, "name": "Eduardo Isamel", "account_id": 9}
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
  -d '{"recipient_account_id": 3, "amount": 10, "description": "Transferencia"}' \
  http://localhost:3000/api/v1/accounts/2/transactions -i
```

**Example Response:**
```json
{
  "message": "Transferencia realizada con éxito",
  "amount": 10.0,
  "source_account": {
    "account_number": "7529739178"
  },
  "recipient_account": {
    "account_number": "9596713885"
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
  -d '{"service_id": 6, "amount": 10, "description": "Pago de servicios"}' \
  http://localhost:3000/api/v1/accounts/1/pay_service -i
