FROM python:3.11

# Copy local context to `/app` inside container (see .dockerignore)
WORKDIR /app
COPY . .

# Copy environment variables file
COPY .env .env

# Install app requirements and reflex in the container
RUN pip install -r requirements.txt

# Load environment variables
RUN export $(cat .env | xargs)

# Deploy templates and prepare app
RUN reflex init

# Download all npm dependencies and compile frontend
RUN reflex export --frontend-only --no-zip

# Needed until Reflex properly passes SIGTERM on backend.
STOPSIGNAL SIGKILL

# Always apply migrations before starting the backend.
CMD [ -d alembic ] && reflex db migrate; reflex run --env prod
