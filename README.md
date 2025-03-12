```markdown
# My Rails Project

## Installation Guide

### Prerequisites

Ensure you have the following installed on your system:

- **Git**
- **Ruby** (version 3.0.0 or later)
- **Rails** (version 6.1 or later)
- **Node.js**
- **Yarn**
- **SQLite3**

### Step-by-Step Installation

#### 1. Clone the Repository

First, clone the repository from GitHub:

```bash
git clone https://github.com/Josephat-Onkoba/Fitness_application.git
cd fitness_application
```

#### 2. Install Ruby

If you don't have Ruby installed, follow the installation guide for your OS:

- **Windows**: [GoRails Setup Guide](https://gorails.com/setup/windows/11)
- **Mac/Linux**: Use `rbenv` or `RVM`:
  
  ```bash
  curl -fsSL https://get.rvm.io | bash -s stable
  rvm install 3.0.0
  rvm use 3.0.0 --default
  ```

#### 3. Install Rails

Install Rails using the following command:

```bash
gem install rails -v 6.1.0
```

#### 4. Install Dependencies

Install the required gems and JavaScript packages:

```bash
bundle install
yarn install
```

#### 5. Configure the Database

Update the database configuration file at:

```bash
config/database.yml
```

Ensure it is correctly set up for SQLite3:

```yaml
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
  database: db/production.sqlite3
```

#### 6. Create and Migrate the Database

Run the following commands to create and migrate the database:

```bash
rails db:create
rails db:migrate
```

#### 7. Run the Server

Start the Rails server using the following command:

```bash
rails server
```

You can now access the application at `http://localhost:3000`.

### Additional Commands

- **Run tests**: `rails test`
- **Open the Rails console**: `rails console`
- **Run database seeds**: `rails db:seed`
- **Check for missing gems**: `bundle check`


