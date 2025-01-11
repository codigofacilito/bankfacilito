# API Documentation

## Users

### Register User
**Endpoint:** `POST /api/v1/register`  
**Description:** Registers a new user in the system.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "string",
    "last_name": "string",
    "email": "string (valid email format)",
    "pin": "string (4-6 digits)"
  }' \
  http://bankfacilito.xyz/api/v1/register -i
```

**Example Response:**
```json
{
  "message": "User registered successfully",
  "token": "string (JWT Token)",
  "user": {
    "id": "integer",
    "first_name": "string",
    "last_name": "string",
    "email": "string"
  },
  "account": {
    "account_number": "string",
    "balance": "float"
  }
}
```

---

### Login User
**Endpoint:** `POST /api/v1/login`  
**Description:** Authenticates a user and provides an access token.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "account_number": "integer",
    "pin": "string (4-6 digits)"
  }' \
  http://bankfacilito.xyz/api/v1/login -i
```

**Example Response:**
```json
{
  "token": "string (JWT Token)"
}
```

---

### Update User
**Endpoint:** `PUT /api/v1/users/{id}/`  
**Description:** Updates user information.

**Request:**
```bash
curl -X PUT \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  -d '{
    "first_name": "string",
    "last_name": "string",
    "email": "string (valid email format)"
  }' \
  http://bankfacilito.xyz/api/v1/users/{id}/ -i
```

**Example Response:**
```json
{
  "id": "integer",
  "first_name": "string",
  "last_name": "string",
  "email": "string"
}
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
  http://bankfacilito.xyz/api/v1/accounts -i
```

**Example Response:**
```json
[
  {
    "id": "integer",
    "user_id": "integer",
    "account_number": "string",
    "clabe": "string",
    "balance": "float"
  }
]
```

---

### Create New Account
**Endpoint:** `POST /api/v1/accounts`  
**Description:** Creates a new account for the authenticated user.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://bankfacilito.xyz/api/v1/accounts/ -i
```

**Example Response:**
```json
{
  "id": "integer",
  "user_id": "integer",
  "account_number": "string",
  "balance": "float",
  "clabe": "string",
  "created_at": "datetime",
  "updated_at": "datetime",
  "default": "boolean",
  "account_type": "string"
}
```

---

### Get Account Details
**Endpoint:** `GET /api/v1/accounts/{account_id}`  
**Description:** Retrieves details of a specific account.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://bankfacilito.xyz/api/v1/accounts/{account_id} -i
```

**Example Response:**
```json
{
  "id": "integer",
  "user_id": "integer",
  "account_number": "string",
  "balance": "float",
  "clabe": "string",
  "created_at": "datetime",
  "updated_at": "datetime",
  "default": "boolean",
  "account_type": "string"
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
  -d '{
    "recipient": {
      "clabe": "string",
      "name": "string"
    }
  }' \
  http://bankfacilito.xyz/api/v1/recipients/ -i
```

**Example Response:**
```json
{
  "id": "integer",
  "user_id": "integer",
  "name": "string",
  "account_id": "integer",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

---

### Get All Recipients
**Endpoint:** `GET /api/v1/recipients`  
**Description:** Retrieves all recipients for the authenticated user.

**Request:**
```bash
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://bankfacilito.xyz/api/v1/recipients/ -i
```

**Example Response:**
```json
[
  {
    "id": "integer",
    "name": "string",
    "account_id": "integer"
  }
]
```

---

### Delete Recipient
**Endpoint:** `DELETE /api/v1/recipients/{id}`  
**Description:** Deletes a specific recipient.

**Request:**
```bash
curl -X DELETE \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  http://bankfacilito.xyz/api/v1/recipients/{id} -i
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
  http://bankfacilito.xyz/api/v1/services/ -i
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
  http://bankfacilito.xyz/api/v1/accounts/{account_id}/transactions -i
```

---

### Create Transaction
**Endpoint:** `POST /api/v1/accounts/{account_id}/transactions`  
**Description:** Creates a new transaction.

**Request:**
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT Token>" \
  -d '{
    "recipient_account_id": "integer",
    "amount": "float",
    "description": "string"
  }' \
  http://bankfacilito.xyz/api/v1/accounts/{account_id}/transactions -i
```

**Example Response:**
```json
{
  "message": "Transaction completed successfully",
  "amount": "float",
  "source_account": {
    "account_number": "string"
  },
  "recipient_account": {
    "account_number": "string"
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
  -d '{
    "service_id": "integer",
    "amount": "float",
    "description": "string"
  }' \
  http://bankfacilito.xyz/api/v1/accounts/{account_id}/pay_service -i
