const { expect } = require('chai');
const request = require('supertest');
const app = require('./index');

describe('Simple Backend API', () => {
  describe('GET /', () => {
    it('should return API running message with endpoints', (done) => {
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('message');
          expect(res.body.message).to.equal('API is running');
          expect(res.body).to.have.property('endpoints');
          expect(res.body.endpoints).to.have.property('health');
          expect(res.body.endpoints).to.have.property('predict');
          done();
        });
    });
  });

  describe('GET /health', () => {
    it('should return healthy status', (done) => {
      request(app)
        .get('/health')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('status');
          expect(res.body.status).to.equal('healthy');
          done();
        });
    });

    it('should return timestamp', (done) => {
      request(app)
        .get('/health')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('timestamp');
          expect(res.body.timestamp).to.match(/^\d{4}-\d{2}-\d{2}T/);
          done();
        });
    });

    it('should return uptime', (done) => {
      request(app)
        .get('/health')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('uptime');
          expect(res.body.uptime).to.be.a('number');
          expect(res.body.uptime).to.be.greaterThan(0);
          done();
        });
    });
  });

  describe('GET /predict', () => {
    it('should return a score of 0.75', (done) => {
      request(app)
        .get('/predict')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('score');
          expect(res.body.score).to.equal(0.75);
          done();
        });
    });
  });

  describe('404 Error Handling', () => {
    it('should return 404 for unknown routes', (done) => {
      request(app)
        .get('/unknown-route')
        .expect(404, done);
    });
  });
});
