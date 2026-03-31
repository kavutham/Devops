# Generic Quick Notes

## Following to deep dive

GitHub Actions and pipeline

Linux and shell questions

From Resume





Application and Network Loadbalancer difference

Classic Load Balancer (CLB): Mainly for TCP (layer 4) and HTTP, HTTPS (layer 7)

Application Load Balancer (ALB): Mainly for HTTP, HTTPS and WebSocket

Network Load Balancer (NLB): Mainly for TCP, TLS and UDP

Gateway Load Balancer (GWLB): Mainly for layer 3 operations (IP protocol)



## Forward Proxy

Between client ' internet

Hides client identity

Use case: Corporate internet filtering, caching



## Reverse Proxy

Between internet ' server

Hides server identity, does load balancing, SSL termination, caching

Use case: HAProxy in Kubernetes sidecar



## CORS (Cross-Origin Resource Sharing)

Browser security: controls which domains can access APIs

Configured at server or reverse proxy



## mTLS

mTLS ensures both sides are verified, not just encryption.

Can be between pods, services, or external clients.

In Kubernetes, usually handled via sidecar proxies (Istio, Linkerd, HAProxy) ' simplifies cert management.

Server verifies client cert against common CA.

Internal traffic usually uses private CA(Venafi, hashocorp vault PKI); external uses public CA (digicert, globalsign).



**REST** is not a protocol but a set of guiding principles that leverage the existing HTTP protocol to enable communication between clients and servers.

**GraphQL endpoint** (/graphql) replaces multiple REST endpoints, allowing clients to structure their own queries instead of relying on predefined responses. It requires complex server, schema and setup whereas Rest uses simple curl or broswer.

REST requires polling or webscokets but GraphQL has subscription to enable client to listen for changes

REST: Multiple endpoints, fixed data, easy HTTP caching, may over-fetch, simple CRUD ' use when resources are stable.

GraphQL: Single endpoint, client chooses data, caching harder, N+1 risk, flexible queries ' use for multi-client APIs.



## API Gateways:

API Gateway is a single entry point for all client requests to backend services.

Handles routing, authentication (Using outh bearer token, api keys)/authorization(Checking client permission using scopes), rate limiting, caching, and monitoring.

**Kong** = gateway, traffic + security (rate limiting, monitoring)

**Stargaze** = UI + scope approval + API documentation + API lifecyle

DAF = Authroziation servce



## Rate Limiting:
Controls the frequency of requests a client can make within a given timeframe.

Protects backend services from being overwhelmed by excessive traffic or potential denial-of-service (DoS) attacks.



## Flow:

Service defines needed scopes with api endpoint it is calling. They use internal daf server to manage the client id and client secret which is present along with the scope.

API call: Includes token (JWT or OAuth2) or requests token from DAF

DAF validates client ID/Secret \& scopes ' issues token

Kong API Gateway: Validates token and scopes \&Forwards request to backend if authorized

Stargaze: Manages approval \& documentation of which services can access which scopes



**CAP Theorem:** You can only fully guarantee to at a time in a distributed system.

C = Consistency ' Every read gets the latest write.

A = Availability ' System always responds, even if some nodes fail.

P = Partition tolerance ' System keeps working even if network splits.

If your system must be fully consistent (like banking balances), you may sacrifice some availability during network issues.



**Idempotency** means: you can perform an operation multiple times, and the result stays the same as if you did it once

APIs: Retrying a request (due to network failure) wont create duplicate records.

SRE perspective: Reduces risk of cascading failures when retries happen automatically.

Think safe to retry " thats the DevOps mindset.



**Cross Site Scripting** is a JavaScript vulnerability in the web applications. The easiest way to explain this is a case when a user enters a script in the client side input fields and that input gets processed without getting validated. This leads to untrusted data getting saved and executed on the client side.



