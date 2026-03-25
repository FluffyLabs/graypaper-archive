---
title: "JAM: Join-Accumulate Machine"
subtitle: "A Mostly-Coherent Trustless Supercomputer"
author: "Dr. Gavin Wood"
version: "0.3.8"
date: "Mon, 23 Sep 2024 08:29:58 +0200"
hash: "387103d8238f7abf3ba38fae16bbf6eb89b24305"
---

We present a comprehensive and formal definition of JAM, a protocol combining elements of both *Polkadot* and *Ethereum*. In a single coherent model, JAM provides a global singleton permissionless object environment---much like the smart-contract environment pioneered by Ethereum---paired with secure sideband computation parallelized over a scalable node network, a proposition pioneered by Polkadot.

JAM introduces a decentralized hybrid system offering smart-contract functionality structured around a secure and scalable in-core/on-chain dualism. While the smart-contract functionality implies some similarities with Ethereum's paradigm, the overall model of the service offered is driven largely by underlying architecture of Polkadot.

JAM is permissionless in nature, allowing anyone to deploy code as a service on it for a fee commensurate with the resources this code utilizes and to induce execution of this code through the procurement and allocation of *core-time*, a metric of resilient and ubiquitous computation, somewhat similar to the purchasing of gas in Ethereum. We already envision a Polkadot-compatible *CoreChains* service.

::: center
![image](assets/jam-pen-back.png){width="10cm"}
:::

::: multicols
2

# 1 Introduction

## 1.1 Nomenclature

In this paper, we introduce a decentralized, crypto-economic protocol to which the Polkadot Network could conceivably transition itself in a major revision. Following this eventuality (which must not be taken for granted since Polkadot is a decentralized network) this protocol might also become known as *Polkadot* or some derivation thereof. However, at this stage this is not the case, therefore our proposed protocol will for the present be known as JAM.

An early, unrefined, version of this protocol was first proposed in Polkadot Fellowship [rfc]{.smallcaps}, known as *CoreJam*. CoreJam takes its name after the collect/refine/join/accumulate model of computation at the heart of its service proposition. While the CoreJam [rfc]{.smallcaps} suggested an incomplete, scope-limited alteration to the Polkadot protocol, JAM refers to a complete and coherent overall blockchain protocol.

## 1.2 Driving Factors

Within the realm of blockchain and the wider Web3, we are driven by the need first and foremost to deliver resilience. A proper Web3 digital system should honor a declared service profile---and ideally meet even perceived expectations---regardless of the desires, wealth or power of any economic actors including individuals, organizations and, indeed, other Web3 systems. Inevitably this is aspirational, and we must be pragmatic over how perfectly this may really be delivered. Nonetheless, a Web3 system should aim to provide such radically strong guarantees that, for practical purposes, the system may be described as *unstoppable*.

While Bitcoin is, perhaps, the first example of such a system within the economic domain, it was not general purpose in terms of the nature of the service it offered. A rules-based service is only as useful as the generality of the rules which may be conceived and placed within it. Bitcoin's rules allowed for an initial use-case, namely a fixed-issuance token, ownership of which is well-approximated and autonomously enforced through knowledge of a secret, as well as some further elaborations on this theme.

Later, Ethereum would provide a categorically more general-purpose rule set, one which was practically Turing complete.[^1] In the context of Web3 where we are aiming to deliver a massively multiuser application platform, generality is crucial, and thus we take this as a given.

Beyond resilience and generality, things get more interesting, and we must look a little deeper to understand what our driving factors are. For the present purposes, we identify three additional goals:

1.  []{#enum:resilience label="enum:resilience"} Resilience: highly resistant from being stopped, corrupted and censored.

2.  []{#enum:generality label="enum:generality"} Generality: able to perform Turing-complete computation.

3.  []{#enum:performance label="enum:performance"} Performance: able to perform computation quickly and at low cost.

4.  []{#enum:coherency label="enum:coherency"} Coherency: the causal relationship possible between different elements of state and thus how well individual applications may be composed.

5.  []{#enum:accessibility label="enum:accessibility"} Accessibility: negligible barriers to innovation; easy, fast, cheap and permissionless.

As a declared Web3 technology, we make an implicit assumption of the first two items. Interestingly, items [\[enum:performance\]](#enum:performance){reference-type="ref" reference="enum:performance"} and [\[enum:coherency\]](#enum:coherency){reference-type="ref" reference="enum:coherency"} are antagonistic according to an information theoretic principle which we are sure must already exist in some form but are nonetheless unaware of a name for it. For argument's sake we shall name it *size-synchrony antagonism*.

## 1.3 Scaling under Size-Synchrony Antagonism

Size-synchrony antagonism is a simple principle implying that as the state-space of information systems grow, then the system necessarily becomes less synchronous. The argument goes:

1.  The more state a system utilizes for its data-processing, the greater the amount of space this state must occupy.

2.  The more space used, then the greater the mean and variance of distances between state-components.

3.  As the mean and variance increase, then interactions become slower and subsystems must manage the possibility that distances between interdependent components of state could be materially different, requiring asynchrony.

This assumes perfect coherency of the system's state. Setting the question of overall security aside for a moment, we can avoid this rule by applying the *divide and conquer* maxim and fragmenting the state of a system, sacrificing its coherency. We might for example create two independent smaller-state systems rather than one large-state system. This pattern applies a step-curve to the principle; intra-system processing has low size and high synchrony, inter-system processing has high size but low synchrony. It is the principle behind meta-networks such as Polkadot, Cosmos and the predominant vision of a scaled Ethereum (all to be discussed in depth shortly).

The present work explores a middle-ground in the antagonism, avoiding the persistent fragmentation of state-space of the system as with existing approaches. We do this by introducing a new model of computation which pipelines a highly scalable element to a highly synchronous element. Asynchrony is not avoided, but we do open the possibility for a greater degree of granularity over how it is traded against size. In particular fragmentation can be made ephemeral rather than persistent, drawing upon a coherent state and fragmenting it only for as long as it takes to execute any given piece of processing on it.

Unlike with [snark]{.smallcaps}-based L2-blockchain techniques for scaling, this model draws upon crypto-economic mechanisms and inherits their low-cost and high-performance profiles and averts a bias toward centralization.

## 1.4 Document Structure

We begin with a brief overview of present scaling approaches in blockchain technology in section [2](#sec:previouswork){reference-type="ref" reference="sec:previouswork"}. In section [3](#sec:notation){reference-type="ref" reference="sec:notation"} we define and clarify the notation from which we will draw for our formalisms.

We follow with a broad overview of the protocol in section [4](#sec:overview){reference-type="ref" reference="sec:overview"} outlining the major areas including the Polka Virtual Machine ([pvm]{.smallcaps}), the consensus protocols Safrole and [Grandpa]{.smallcaps}, the common clock and build the foundations of the formalism.

We then continue with the full protocol definition split into two parts: firstly the correct on-chain state-transition formula helpful for all nodes wishing to validate the chain state, and secondly, in sections [14](#sec:workpackagesandworkreports){reference-type="ref" reference="sec:workpackagesandworkreports"} and [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"} the honest strategy for the off-chain actions of any actors who wield a validator key.

The main body ends with a discussion over the performance characteristics of the protocol in section [20](#sec:discussion){reference-type="ref" reference="sec:discussion"} and finally conclude in section [21](#sec:conclusion){reference-type="ref" reference="sec:conclusion"}.

The appendix contains various additional material important for the protocol definition including the [pvm]{.smallcaps} in appendices [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"} & [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}, serialization and Merklization in appendices [26](#sec:serialization){reference-type="ref" reference="sec:serialization"} & [27](#sec:statemerklization){reference-type="ref" reference="sec:statemerklization"} and cryptography in appendices [28](#sec:merklization){reference-type="ref" reference="sec:merklization"}, [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"} & [31](#sec:erasurecoding){reference-type="ref" reference="sec:erasurecoding"}. We finish with an index of terms which includes the values of all simple constant terms used in the work in appendix [32](#sec:definitions){reference-type="ref" reference="sec:definitions"}, and close with the bibliography.

# 2 Previous Work and Present Trends {#sec:previouswork}

In the years since the initial publication of the Ethereum *YP*, the field of blockchain development has grown immensely. Other than scalability, development has been done around underlying consensus algorithms, smart-contract languages and machines and overall state environments. While interesting, these latter subjects are mostly out scope of the present work since they generally do not impact underlying scalability.

## 2.1 Polkadot

In order to deliver its service, JAM co-opts much of the same game-theoretic and cryptographic machinery as Polkadot known as [Elves]{.smallcaps} and described by [@cryptoeprint:2024/961]. However, major differences exist in the actual service offered with JAM, providing an abstraction much closer to the actual computation model generated by the validator nodes its economy incentivizes.

It was a major point of the original Polkadot proposal, a scalable heterogeneous multichain, to deliver high-performance through partition and distribution of the workload over multiple host machines. In doing so it took an explicit position that composability would be lowered. Polkadot's constituent components, parachains are, practically speaking, highly isolated in their nature. Though a message passing system ([xcmp]{.smallcaps}) exists it is asynchronous, coarse-grained and practically limited by its reliance on a high-level slowly evolving interaction language [xcm]{.smallcaps}.

As such, the composability offered by Polkadot between its constituent chains is lower than that of Ethereum-like smart-contract systems offering a single and universal object environment and allowing for the kind of agile and innovative integration which underpins their success. Polkadot, as it stands, is a collection of independent ecosystems with only limited opportunity for collaboration, very similar in ergonomics to bridged blockchains though with a categorically different security profile. A technical proposal known as [spree]{.smallcaps} would utilize Polkadot's unique shared-security and improve composability, though blockchains would still remain isolated.

Implementing and launching a blockchain is hard, time-consuming and costly. By its original design, Polkadot limits the clients able to utilize its service to those who are both able to do this and raise a sufficient deposit to win an auction for a long-term slot, one of around 50 at the present time. While not permissioned per se, accessibility is categorically and substantially lower than for smart-contract systems similar to Ethereum.

Enabling as many innovators to participate and interact, both with each other and each other's user-base, appears to be an important component of success for a Web3 application platform. Accessibility is therefore crucial.

## 2.2 Ethereum

The Ethereum protocol was formally defined in this paper's spiritual predecessor, the *Yellow Paper*, by [@wood2014ethereum]. This was derived in large part from the initial concept paper by [@buterin2013ethereum]. In the decade since the *YP* was published, the *de facto* Ethereum protocol and public network instance have gone through a number of evolutions, primarily structured around introducing flexibility via the transaction format and the instruction set and "precompiles" (niche, sophisticated bonus instructions) of its scripting core, the Ethereum virtual machine ([evm]{.smallcaps}).

Almost one million crypto-economic actors take part in the validation for Ethereum.[^2] Block extension is done through a randomized leader-rotation method where the physical address of the leader is public in advance of their block production.[^3] Ethereum uses Casper-FFG introduced by [@buterin2019casper] to determine finality, which with the large validator base finalizes the chain extension around every 13 minutes.

Ethereum's direct computational performance remains broadly similar to that with which it launched in 2015, with a notable exception that an additional service now allows 1[mb]{.smallcaps} of *commitment data* to be hosted per block (all nodes to store it for a limited period). The data cannot be directly utilized by the main state-transition function, but special functions provide proof that the data (or some subsection thereof) is available. According to [@ethereum2024danksharding], the present design direction is to improve on this over the coming years by splitting responsibility for its storage amongst the validator base in a protocol known as *Dank-sharding*.

According to [@ethereum2024sigital], the scaling strategy of Ethereum would be to couple this data availability with a private market of *roll-ups*, sideband computation facilities of various design, with [zk-snark]{.smallcaps}-based roll-ups being a stated preference. Each vendor's roll-up design, execution and operation comes with its own implications.

One might reasonably assume that a diversified market-based approach for scaling via multivendor roll-ups will allow well-designed solutions to thrive. However, there are potential issues facing the strategy. A research report by [@sharma2024ethereums] on the level of decentralization in the various roll-ups found a broad pattern of centralization, but notes that work is underway to attempt to mitigate this. It remains to be seen how decentralized they can yet be made.

Heterogeneous communication properties (such as datagram latency and semantic range), security properties (such as the costs for reversion, corruption, stalling and censorship) and economic properties (the cost of accepting and processing some incoming message or transaction) may differ, potentially quite dramatically, between major areas of some grand patchwork of roll-ups by various competing vendors. While the overall Ethereum network may eventually provide some or even most of the underlying machinery needed to do the sideband computation it is far from clear that there would be a "grand consolidation" of the various properties should such a thing happen. We have not found any good discussion of the negative ramifications of such a fragmented approach.[^4]

### 2.2.1 [Snark]{.smallcaps} Roll-ups

While the protocol's foundation makes no great presuppositions on the nature of roll-ups, Ethereum's strategy for sideband computation does centre around [snark]{.smallcaps}-based rollups and as such the protocol is being evolved into a design that makes sense for this. [Snark]{.smallcaps}s are the product of an area of exotic cryptography which allow proofs to be constructed to demonstrate to a neutral observer that the purported result of performing some predefined computation is correct. The complexity of the verification of these proofs tends to be sub-linear in their size of computation to be proven and will not give away any of the internals of said computation, nor any dependent witness data on which it may rely.

[Zk-snark]{.smallcaps}s come with constraints. There is a trade-off between the proof's size, verification complexity and the computational complexity of generating it. Non-trivial computation, and especially the sort of general-purpose computation laden with binary manipulation which makes smart-contracts so appealing, is hard to fit into the model of [snark]{.smallcaps}s.

To give a practical example, [risc]{.smallcaps}-zero (as assessed by [@bogli2024assessing]) is a leading project and provides a platform for producing [snark]{.smallcaps}s of computation done by a [risc-v]{.smallcaps} virtual machine, an open-source and succinct [risc]{.smallcaps} machine architecture well-supported by tooling. A recent benchmarking report by [@koute2024risc0] showed that compared to [risc]{.smallcaps}-zero's own benchmark, proof generation alone takes over 61,000 times as long as simply recompiling and executing even when executing on 32 times as many cores, using 20,000 times as much [ram]{.smallcaps} and an additional state-of-the-art [gpu]{.smallcaps}. According to hardware rental agents <https://cloud-gpus.com/>, the cost multiplier of proving using [risc]{.smallcaps}-zero is 66,000,000x of the cost[^5] to execute using our [risc-v]{.smallcaps} recompiler.

Many cryptographic primitives become too expensive to be practical to use and specialized algorithms and structures must be substituted. Often times they are otherwise suboptimal. In expectation of the use of [snark]{.smallcaps}s (such as [plonk]{.smallcaps} as proposed by [@cryptoeprint:2019/953]), the prevailing design of the Ethereum project's Dank-sharding availability system uses a form of erasure coding centered around polynomial commitments over a large prime field in order to allow [snark]{.smallcaps}s to get acceptably performant access to subsections of data. Compared to alternatives, such as a binary field and Merklization in the present work, it leads to a load on the validator nodes orders of magnitude higher in terms of [cpu]{.smallcaps} usage.

In addition to their basic cost, [snark]{.smallcaps}s present no great escape from decentralization and the need for redundancy, leading to further cost multiples. While the need for some benefits of staked decentralization is averted through their verifiable nature, the need to incentivize multiple parties to do much the same work is a requirement to ensure that a single party not form a monopoly (or several not form a cartel). Proving an incorrect state-transition should be impossible, however service integrity may be compromised in other ways; a temporary suspension of proof-generation, even if only for minutes, could amount to major economic ramifications for real-time financial applications.

Real-world examples exist of the pit of centralization giving rise to monopolies. One would be the aforementioned [snark]{.smallcaps}-based exchange framework; while notionally serving decentralized exchanges, it is in fact centralized with Starkware itself wielding a monopoly over enacting trades through the generation and submission of proofs, leading to a single point of failure---should Starkware's service become compromised, then the liveness of the system would suffer.

It has yet to be demonstrated that [snark]{.smallcaps}-based strategies for eliminating the trust from computation will ever be able to compete on a cost-basis with a multi-party crypto-economic platform. All as-yet proposed [snark]{.smallcaps}-based solutions are heavily reliant on crypto-economic systems to frame them and work around their issues. Data availability and sequencing are two areas well understood as requiring a crypto-economic solution.

We would note that [snark]{.smallcaps} technology is improving and the cryptographers and engineers behind them do expect improvements in the coming years. In a recent article by [@thaler2023technical] we see some credible speculation that with some recent advancements in cryptographic techniques, slowdowns for proof generation could be as little as 50,000x from regular native execution and much of this could be parallelized. This is substantially better than the present situation, but still several orders of magnitude greater than would be required to compete on a cost-basis with established crypto-economic techniques such as [Elves]{.smallcaps}.

## 2.3 Fragmented Meta-Networks

Directions for general-purpose computation scalability taken by other projects broadly centre around one of two approaches; either what might be termed a *fragmentation* approach or alternatively a *centralization* approach. We argue that neither approach offers a compelling solution.

The fragmentation approach is heralded by projects such as Cosmos (proposed by [@kwon2019cosmos]) and Avalanche (by [@tanana2019avalanche]). It involves a system fragmented by networks of a homogenous consensus mechanic, yet staffed by separately motivated sets of validators. This is in contrast to Polkadot's single validator set and Ethereum's declared strategy of heterogeneous roll-ups secured partially by the same validator set operating under a coherent incentive framework. The homogeneity of said fragmentation approach allows for reasonably consistent messaging mechanics, helping to present a fairly unified interface to the multitude of connected networks.

However, the apparent consistency is superficial. The networks are trustless only by assuming correct operation of their validators, who operate under a crypto-economic security framework ultimately conjured and enforced by economic incentives and punishments. To do twice as much work with the same levels of security and no special coordination between validator sets, then such systems essentially prescribe forming a new network with the same overall levels of incentivization.

Several problems arise. Firstly, there is a similar downside as with Polkadot's isolated parachains and Ethereum's isolated roll-up chains: a lack of coherency due to a persistently sharded state preventing synchronous composability.

More problematically, the scaling-by-fragmentation approach, proposed specifically by Cosmos, provides no homogenous security---and therefore trustlessness---guarantees. Validator sets between networks must be assumed to be independently selected and incentivized with no relationship, causal or probabilistic, between the Byzantine actions of a party on one network and potential for appropriate repercussions on another. Essentially, this means that should validators conspire to corrupt or revert the state of one network, the effects may be felt across other networks of the ecosystem.

That this is an issue is broadly accepted, and projects propose for it to be addressed in one of two ways. Firstly, to fix the expected cost-of-attack (and thus level of security) across networks by drawing from the same validator set. The massively redundant way of doing this, as proposed by [@cosmos2024interchain] under the name *replicated security*, would be to require each validator to validate on all networks and for the same incentives and punishments. This is economically inefficient in the cost of security provision as each network would need to independently provide the same level of incentives and punishment-requirements as the most secure with which it wanted to interoperate. This is to ensure the economic proposition remain unchanged for validators and the security proposition remained equivalent for all networks. At the present time, replicated security is not a readily available permissionless service. We might speculate that these punishing economics have something to do with it.

The more efficient approach, proposed by the OmniLedger team, [@cryptoeprint:2017/406], would be to make the validators non-redundant, partitioning them between different networks and periodically, securely and randomly repartitioning them. A reduction in the cost to attack over having them all validate on a single network is implied since there is a chance of having a single network accidentally have a compromising number of malicious validators even with less than this proportion overall. This aside it presents an effective means of scaling under a basis of weak-coherency.

Alternatively, as in [Elves]{.smallcaps} by [@cryptoeprint:2024/961], we may utilize non-redundant partitioning, combine this with a proposal-and-auditing game which validators play to weed out and punish invalid computations, and then require that the finality of one network be contingent on all causally-entangled networks. This is the most secure and economically efficient solution of the three, since there is a mechanism for being highly confident that invalid transitions will be recognized and corrected before their effect is finalized across the ecosystem of networks. However, it requires substantially more sophisticated logic and their causal-entanglement implies some upper limit on the number of networks which may be added.

## 2.4 High-Performance Fully Synchronous Networks

Another trend in the recent years of blockchain development has been to make "tactical" optimizations over data throughput by limiting the validator set size or diversity, focusing on software optimizations, requiring a higher degree of coherency between validators, onerous requirements on the hardware which validators must have, or limiting data availability.

The Solana blockchain is underpinned by technology introduced by [@yakovenko2018solana] and boasts theoretical figures of over 700,000 transactions per second, though according to [@ng2024is] the network is only seen processing a small fraction of this. The underlying throughput is still substantially more than most blockchain networks and is owed to various engineering optimizations in favor of maximizing synchronous performance. The result is a highly-coherent smart-contract environment with an [api]{.smallcaps} not unlike that of *YP* Ethereum (albeit using a different underlying [vm]{.smallcaps}), but with a near-instant time to inclusion and finality which is taken to be immediate upon inclusion.

Two issues arise with such an approach: firstly, defining the protocol as the outcome of a heavily optimized codebase creates structural centralization and can undermine resilience. [@jha2024solana] writes "since January 2022, 11 significant outages gave rise to 15 days in which major or partial outages were experienced". This is an outlier within the major blockchains as the vast majority of major chains have no downtime. There are various causes to this downtime, but they are generally due to bugs found in various subsystems.

Ethereum, at least until recently, provided the most contrasting alternative with its well-reviewed specification, clear research over its crypto-economic foundations and multiple clean-room implementations. It is perhaps no surprise that the network very notably continued largely unabated when a flaw in its most deployed implementation was found and maliciously exploited, as described by [@hertig2016so].

The second issue is concerning ultimate scalability of the protocol when it provides no means of distributing workload beyond the hardware of a single machine.

In major usage, both historical transaction data and state would grow impractically. Solana illustrates how much of a problem this can be. Unlike classical blockchains, the Solana protocol offers no solution for the archival and subsequent review of historical data, crucial if the present state is to be proven correct from first principle by a third party. There is little information on how Solana manages this in the literature, but according to [@solana2023solana], nodes simply place the data onto a centralized database hosted by Google.[^6]

Solana validators are encouraged to install large amounts of [ram]{.smallcaps} to help hold its large state in memory (512 [gb]{.smallcaps} is the current recommendation according to [@solana2024solana]). Without a divide-and-conquer approach, Solana shows that the level of hardware which validators can reasonably be expected to provide dictates the upper limit on the performance of a totally synchronous, coherent execution model. Hardware requirements represent barriers to entry for the validator set and cannot grow without sacrificing decentralization and, ultimately, transparency.

# 3 Notational Conventions {#sec:notation}

Much as in the Ethereum Yellow Paper, a number of notational conventions are used throughout the present work. We define them here for clarity. The Ethereum Yellow Paper itself may be referred to henceforth as the *YP*.

## 3.1 Typography {#sec:typography}

We use a number of different typefaces to denote different kinds of terms. Where a term is used to refer to a value only relevant within some localized section of the document, we use a lower-case roman letter e.g. $x$, $y$ (typically used for an item of a set or sequence) or e.g. $i$, $j$ (typically used for numerical indices). Where we refer to a Boolean term or a function in a local context, we tend to use a capitalized roman alphabet letter such as $A$, $F$. If particular emphasis is needed on the fact a term is sophisticated or multidimensional, then we may use a bold typeface, especially in the case of sequences and sets.

For items which retain their definition throughout the present work, we use other typographic conventions. Sets are usually referred to with a blackboard typeface, e.g. $\N$ refers to all natural numbers including zero. Sets which may be parameterized may be subscripted or be followed by parenthesized arguments. Imported functions, used by the present work but not specifically introduced by it, are written in calligraphic typeface, e.g. $\mathcal{H}$ the Blake2 cryptographic hashing function. For other non-context dependent functions introduced in the present work, we use upper case Greek letters, e.g. $\Upsilon$ denotes the state transition function.

Values which are not fixed but nonetheless hold some consistent meaning throughout the present work are denoted with lower case Greek letters such as $\sigma$, the state identifier. These may be placed in bold typeface to denote that they refer to an abnormally complex value.

## 3.2 Functions and Operators {#sec:functions}

We define the precedes relation to indicate that one term is defined in terms of another. E.g. $y \prec x$ indicates that $y$ may be defined purely in terms of $x$: $$\begin{aligned}
\label{eq:precedes}
  y \prec x \Longleftrightarrow \exists f: y = f(x)\end{aligned}$$

The substitute-if-nothing function $\mathcal{U}$ is equivalent to the first argument which is not $\none$, or $\none$ if no such argument exists: $$\begin{aligned}
\label{eq:substituteifnothing}
  \mathcal{U}(a_0, \dots a_n ) \equiv a_x : (a_x \ne \none \vee x = n), \bigwedge_{i=0}^{x-1} a_i = \none\end{aligned}$$ Thus, e.g. $\mathcal{U}(\none, 1, \none, 2) = 1$ and $\mathcal{U}(\none, \none) = \none$.

## 3.3 Sets {#sec:sets}

Given some set $\mathbf{s}$, its power set and cardinality are denoted as the usual $\powset{\mathbf{s}}$ and $|\mathbf{s}|$. When forming a power set, we may use a numeric subscript in order to restrict the resultant expansion to a particular cardinality. E.g. $\powset[2]{\{1, 2, 3\}} = \{ \{1, 2\}, \{1, 3\}, \{2, 3\} \}$.

Sets may be operated on with scalars, in which case the result is a set with the operation applied to each element, e.g. $\{1, 2, 3\} + 3 = \{4, 5, 6\}$

We denote set-disjointness with the relation $\disjoint$. Formally: $$A \cap B = \none \Longleftrightarrow A \disjoint B$$

We commonly use $\none$ to indicate that some term is validly left without a specific value. Its cardinality is defined as zero. We define the operation $\bm{?}$ such that $A\bm{?} \equiv A \cup \{\none\}$ indicating the same set but with the addition of the $\none$ element.

The term $\error$ is utilized to indicate the unexpected failure of an operation or that a value is invalid or unexpected. (We try to avoid the use of the more conventional $\bot$ here to avoid confusion with Boolean false, which may be interpreted as some successful result in some contexts.)

## 3.4 Numbers {#sec:numbers}

$\N$ denotes the set of naturals including zero whereas $\N_n$ implies a restriction on that set to values less than $n$. Formally, $\N = \{0, 1, \dots \}$ and $\N_n = \{ x \mid x \in \N, x < n \}$.

$\mathbb{Z}$ denotes the set of integers. We denote $\mathbb{Z}_{a \dots b}$ to be the set of integers within the interval $[a, b)$. Formally, $\mathbb{Z}_{a \dots b} = \{ x \mid x \in \mathbb{Z}, a \le x < b \}$. E.g. $\mathbb{Z}_{2 \dots 5} = \{ 2, 3, 4 \}$. We denote the offset/length form of this set as $\mathbb{Z}_{a \dots +b}$, a short form of $\mathbb{Z}_{a \dots a+b}$.

It can sometimes be useful to represent lengths of sequences and yet limit their size, especially when dealing with sequences of octets which must be stored practically. Typically, these lengths can be defined as the set $\N_{2^{32}}$. To improve clarity, we denote $\N_L$ as the set of lengths of octet sequences and is equivalent to $\N_{2^{32}}$.

We denote the $\rem$ operator as the modulo operator, e.g. $5 \rem 3 = 2$. Furthermore, we may occasionally express a division result as a quotient and remainder with the separator $\remainder$, e.g. $5 \div 3 = 1 \remainder 2$.

## 3.5 Dictionaries {#sec:dictionaries}

A *dictionary* is a possibly partial mapping from some domain into some co-domain in much the same manner as a regular function. Unlike functions however, with dictionaries the total set of pairings are necessarily enumerable, and we represent them in some data structure as the set of all $(key \mapsto value)$ pairs. (In such data-defined mappings, it is common to name the values within the domain a *key* and the values within the co-domain a *value*, hence the naming.)

Thus, we define the formalism $\dict{\mathrm{K}}{\mathrm{V}}$ to denote a dictionary which maps from the domain $\mathrm{K}$ to the range $\mathrm{V}$. We define a dictionary as a member of the set of all dictionaries $\mathbb{D}$ and a set of pairs $p = (k \mapsto v)$: $$\begin{aligned}
  &\mathbb{D} \subset \big \{ \{ (k \mapsto v) \} \big \}\end{aligned}$$

A dictionary's members must associate at most one unique value for any key $k$: $$\begin{aligned}
  \forall \mathbf{d} \in\ &\mathbb{D} : \forall (k \mapsto v) \in \mathbf{d} : \exists! v' : (k \mapsto v') \in \mathbf{d}\end{aligned}$$

This assertion allows us to unambiguously define the subscript and subtraction operator for a dictionary $d$: $$\begin{aligned}
  \forall \mathbf{d} \in \mathbb{D}&: \mathbf{d}[k] \equiv \begin{cases}
    v & \text{if}\ \exists k : (k \mapsto v) \in \mathbf{d} \\
    \none & \otherwise
  \end{cases}\\
  \forall \mathbf{d} \in \mathbb{D}&, \mathbf{s} \subseteq K: \mathbf{d} \setminus \mathbf{s} \equiv \{ (k \mapsto v): (k \mapsto v) \in \mathbf{d}, k \not \in \mathbf{s} \}\end{aligned}$$

Note that when using a subscript, it is an implicit assertion that the key exists in the dictionary. Should the key not exist, the result is undefined and any block which relies on it must be considered invalid.

It is typically useful to limit the sets from which the keys and values may be drawn. Formally, we define a typed dictionary $\dict{K}{V}$ as a set of pairs $p$ of the form $(k \mapsto v)$: $$\begin{aligned}
  \dict{K}{V} &\subset \mathbb{D} \\
  \dict{K}{V} &\equiv \big \{ \{ (k \mapsto v) \mid k \in K \wedge v \in V \} \big \}\end{aligned}$$

To denote the active domain (i.e. set of keys) of a dictionary $\mathbf{d} \in \dict{K}{V}$, we use $\keys{\mathbf{d}} \subseteq K$ and for the range (i.e. set of values), $\mathcal{V}(\mathbf{d}) \subseteq V$. Formally: $$\begin{aligned}
  \keys{\mathbf{d} \in \mathbb{D}} &\equiv \{\ k \mid \exists v : (k \mapsto v) \in \mathbf{d}\ \} \\
  \mathcal{V}(\mathbf{d} \in \mathbb{D}) &\equiv \{\ v \mid \exists k : (k \mapsto v) \in \mathbf{d}\ \}\end{aligned}$$

Note that since the co-domain of $\mathcal{V}$ is a set, should different keys with equal values appear in the dictionary, the set will only contain one such value.

## 3.6 Tuples {#sec:tuples}

Tuples are groups of values where each item may belong to a different set. They are denoted with parentheses, e.g. the tuple $t$ of the naturals $3$ and $5$ is denoted $t = (3, 5)$, and it exists in the set of natural pairs sometimes denoted $\N \times \N$, but denoted in the present work as $(\N, \N)$.

We have frequent need to refer to a specific item within a tuple value and as such find it convenient to declare a name for each item. E.g. we may denote a tuple with two named natural components $a$ and $b$ as $T = \ltuple\isa{a}{\N}\ts\isa{b}{\N}\rtuple$. We would denote an item $t \in T$ through subscripting its name, thus for some $t = \ltup\is{a}{3}\ts\is{b}{5}\rtup$, $t_a = 3$ and $t_b = 5$.

## 3.7 Sequences {#sec:sequences}

A sequence is a series of elements with particular ordering not dependent on their values. The set of sequences of elements all of which are drawn from some set $T$ is denoted $\seq{T}$, and it defines a partial mapping $\N \to T$. The set of sequences containing exactly $n$ elements each a member of the set $T$ may be denoted $\seq{T}_n$ and accordingly defines a complete mapping $\N_n \to T$. Similarly, sets of sequences of at most $n$ elements and at least $n$ elements may be denoted $\seq{T}_{:n}$ and $\seq{T}_{n:}$ respectively.

Sequences are subscriptable, thus a specific item at index $i$ within a sequence $\mathbf{s}$ may be denoted $\mathbf{s}[i]$, or where unambiguous, $\mathbf{s}_i$. A range may be denoted using an ellipsis for example: $[0, 1, 2, 3]_{\dots2} = [0, 1]$ and $[0, 1, 2, 3]_{1\dots+2} = [1, 2]$. The length of such a sequence may be denoted $|\mathbf{s}|$.

We denote modulo subscription as $\mathbf{s}[i]^\circlearrowleft \equiv \mathbf{s}[\,i \rem |\mathbf{s}|\,]$. We denote the final element $x$ of a sequence $\mathbf{s} = \sq{..., x}$ through the function $\text{last}(\mathbf{s}) \equiv x$.

### 3.7.1 Construction

We may wish to define a sequence in terms of incremental subscripts of other values: $[\mathbf{x}_0, \mathbf{x}_1, \dots ]_n$ denotes a sequence of $n$ values beginning $\mathbf{x}_0$ continuing up to $\mathbf{x}_{n-1}$. Furthermore, we may also wish to define a sequence as elements each of which are a function of their index $i$; in this case we denote $[f(i) \mid i \orderedin \N_n] \equiv [f(0), f(1), \dots, f(n - 1)]$. Thus, when the ordering of elements matters we use $\orderedin$ rather than the unordered notation $\in$. The latter may also be written in short form $[f(i \orderedin \N_n)]$. This applies to any set which has an unambiguous ordering, particularly sequences, thus $[\,i^2 \mid i \orderedin [1, 2, 3]\,] = [1, 4, 9]$. Multiple sequences may be combined, thus $[\,i\cdot j \mid i \orderedin [1, 2, 3], j \orderedin [2, 3, 4]\,] = [2, 6, 12]$.

We use explicit notation $f^{\#}$ to denote a function mapping over all items of a sequence. Thus given some function $y = f(x)$: $$= f^{\#}([\mathbf{x}_0, \mathbf{x}_1, \dots])$$

Sequences may be constructed from sets or other sequences whose order should be ignored through sequence ordering notation $\orderby{i_k}{i \in X}$, which is defined to result in the set or sequence of its argument except that all elements $i$ are placed in ascending order of the corresponding value $i_k$.

The key component may be elided in which case it is assumed to be ordered by the elements directly; i.e. $\order{i \in X} \equiv \orderby{i}{i \in X}$. $\orderuniqby{i_k}{i \in X}$ does the same, but excludes any duplicate values of $i$. E.g. assuming $\mathbf{s} = [1, 3, 2, 3]$, then $\orderuniqby{i}{i \in \mathbf{s}} = [ 1, 2, 3 ]$ and $\orderby{-i}{i \in \mathbf{s}} = [ 3, 3, 2, 1 ]$.

Sets may be constructed from sequences with the regular set construction syntax, e.g. assuming $\mathbf{s} = [1, 2, 3, 1]$, then $\{ a \mid a \in \mathbf{s} \}$ would be equivalent to $\{ 1, 2, 3 \}$.

Sequences of values which themselves have a defined ordering have an implied ordering akin to a regular dictionary, thus $[1, 2, 3] < [1, 2, 4]$ and $[1, 2, 3] < [1, 2, 3, 1]$.

### 3.7.2 Editing

We define the sequence concatenation operator $\frown$ such that $[\mathbf{x}_0, \mathbf{x}_1, \dots, \mathbf{y}_0, \mathbf{y}_1, \dots] \equiv \mathbf{x} \frown \mathbf{y}$. For sequences of sequences, we define a unary concatenate-all operator: $\wideparen{\mathbf{x}}\equiv\mathbf{x}_0 \frown \mathbf{x}_1 \frown \dots$. Further, we denote element concatenation as $x \doubleplus i \equiv x \frown [i]$. We denote the sequence made up of the first $n$ elements of sequence $\mathbf{s}$ to be ${\overrightarrow{\mathbf{s}}}^n \equiv [\mathbf{s}_0, \mathbf{s}_1, \dots, \mathbf{s}_{n-1}]$, and only the final elements as ${\overleftarrow{\mathbf{s}}}^n$.

We define ${}^\text{T}\mathbf{x}$ as the transposition of the sequence-of-sequences $\mathbf{x}$, fully defined in equation [\[eq:transpose\]](#eq:transpose){reference-type="ref" reference="eq:transpose"}. We may also apply this to sequences-of-tuples to yield a tuple of sequences.

We denote sequence subtraction with a slight modification of the set subtraction operator; specifically, some sequence $\mathbf{s}$ excepting the left-most element equal to $v$ would be denoted $\mathbf{s}\seqminusl\{v\}$.

### 3.7.3 Boolean values

$\mathbb{B}_s$ denotes the set of Boolean strings of length $s$, thus $\mathbb{B}_s = \seq{\{\bot, \top\}}_s$. When dealing with Boolean values we may assume an implicit equivalence mapping to a bit whereby $\top = 1$ and $\bot = 0$, thus $\mathbb{B}_\Box = \seq{\N_2}_\Box$. We use the function $\text{bits}(\Y) \in \mathbb{B}$ to denote the sequence of bits, ordered with the least significant first, which represent the octet sequence $\Y$, thus $\text{bits}([5, 0]) = [1, 0, 1, 0, 0, \dots]$.

### 3.7.4 Octets and Blobs

$\Y$ denotes the set of octet strings ("blobs") of arbitrary length. As might be expected, $\Y_x$ denotes the set of such sequences of length $x$. $\Y_\$$ denotes the subset of $\Y$ which are ASCII-encoded strings. Note that while an octet has an implicit and obvious bijective relationship with natural numbers less than 256, and we may implicitly coerce between octet form and natural number form, we do not treat them as exactly equivalent entities. In particular for the purpose of serialization, an octet is always serialized to itself, whereas a natural number may be serialized as a sequence of potentially several octets, depending on its magnitude and the encoding variant.

### 3.7.5 Shuffling

We define the sequence-shuffle function $\mathcal{F}$, originally introduced by [@fisheryates1938statistical], with an efficient in-place algorithm described by [@wikipedia2024fisheryates]. This accepts a sequence and some entropy and returns a sequence of the same length with the same elements but in an order determined by the entropy. The entropy may be provided as either an indefinite sequence of naturals or a hash. For a full definition see appendix [29](#sec:shuffle){reference-type="ref" reference="sec:shuffle"}.

## 3.8 Cryptography {#sec:cryptography}

### 3.8.1 Hashing

$\H$ denotes the set of 256-bit values typically expected to be arrived at through a cryptographic function, equivalent to $\Y_{32}$, with $\H^0$ being equal to $[0]_{32}$. We assume a function $\mathcal{H}(m \in \Y) \in \H$ denoting the Blake2b 256-bit hash introduced by [@rfc7693] and a function $\mathcal{H}_K(m \in \Y) \in \H$ denoting the Keccak 256-bit hash as proposed by [@bertoni2013keccak] and utilized by [@wood2014ethereum].

We may sometimes wish to take only the first $x$ octets of a hash, in which case we denote $\mathcal{H}_x(m) \in \Y_x$ to be the first $x$ octets of $\mathcal{H}(m)$. The inputs of a hash function are generally assumed to be serialized with our codec $\mathcal{E}(x) \in \Y$, however for the purposes of clarity or unambiguity we may also explicitly denote the serialization. Similarly, we may wish to interpret a sequence of octets as some other kind of value with the assumed decoder function $\de(x \in \Y)$. In both cases, we may subscript the transformation function with the number of octets we expect the octet sequence term to have. Thus, $r = \mathcal{E}_4(x \in \N)$ would assert $x \in \N_{2^{32}}$ and $r \in \Y_4$, whereas $s = \de_8(y)$ would assert $y \in \Y_8$ and $s \in \N_{2^{64}}$.

### 3.8.2 Signing Schemes {#sec:signing}

$\sig{k}{m} \subset \Y_{64}$ is the set of valid Ed25519 signatures, defined by [@rfc8032], made through knowledge of a secret key whose public key counterpart is $k \in \Y_{32}$ and whose message is $m$. To aid readability, we denote the set of valid public keys $k \in \H_E$.

We use $\Y_{BLS} \subset \Y_{144}$ to denote the set of public keys for the [bls]{.smallcaps} signature scheme, described by [@jofc-2004-14130], on curve [bls]{.smallcaps}- defined by [@bls12-381].

We denote the set of valid Bandersnatch public keys as $\H_B$, defined in appendix [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"}. $\bandersig{k \in \H_B}{x \in \Y}{m \in \Y} \subset \Y_{96}$ is the set of valid singly-contextualized signatures of utilizing the secret counterpart to the public key $k$, some context $x$ and message $m$.

$\bandersnatch{r \in \Y_R}{x \in \Y}{m \in \Y} \subset \Y_{784}$, meanwhile, is the set of valid Bandersnatch Ring[vrf]{.smallcaps} deterministic singly-contextualized proofs of knowledge of a secret within some set of secrets identified by some root in the set of valid *roots* $\Y_R \subset \Y_{144}$. We denote $\mathcal{O}(\mathbf{s} \in \seq{\H_B}) \in \Y_R$ to be the root specific to the set of public key counterparts $\mathbf{s}$. A root implies a specific set of Bandersnatch key pairs, knowledge of one of the secrets would imply being capable of making a unique, valid---and anonymous---proof of knowledge of a unique secret within the set.

Both the Bandersnatch signature and Ring[vrf]{.smallcaps} proof strictly imply that a member utilized their secret key in combination with both the context $x$ and the message $m$; the difference is that the member is identified in the former and is anonymous in the latter. Furthermore, both define a [vrf]{.smallcaps} *output*, a high entropy hash influenced by $x$ but not by $m$, formally denoted $\banderout{\bandersnatch{r}{x}{m}} \subset \H$ and $\banderout{\bandersig{k}{x}{m}} \subset \H$.

We define the function $\mathcal{S}$ as the signature function, such that $\mathcal{S}_{k}(m) \in \bandersig{k}{[]}{m} \cup \sig{k}{m}$. We assert that the ability to compute a result for this function relies on knowledge of a secret key.

# 4 Overview {#sec:overview}

As in the Yellow Paper, we begin our formalisms by recalling that a blockchain may be defined as a pairing of some initial state together with a block-level state-transition function. The latter defines the posterior state given a pairing of some prior state and a block of data applied to it. Formally, we say: $$\begin{aligned}
\label{eq:statetransition}
\sigma' \equiv \Upsilon(\sigma, \mathbf{B})\end{aligned}$$

Where $\sigma$ is the prior state, $\sigma'$ is the posterior state, $B$ is some valid block and $\Upsilon$ is our block-level state-transition function.

Broadly speaking, JAM (and indeed blockchains in general) may be defined simply by specifying $\Upsilon$ and some *genesis state* $\sigma^0$.[^7] We also make several additional assumptions of agreed knowledge: a universally known clock, and the practical means of sharing data with other systems operating under the same consensus rules. The latter two were both assumptions silently made in the *YP*.

## 4.1 The Block

To aid comprehension and definition of our protocol, we partition as many of our terms as possible into their functional components. We begin with the block $B$ which may be restated as the header $H$ and some input data external to the system and thus said to be *extrinsic*, $\mathbf{E}$: $$\begin{aligned}
  \label{eq:block}\mathbf{B} &\equiv (\mathbf{H}, \mathbf{E}) \\
  \label{eq:extrinsic}\mathbf{E} &\equiv (\xttickets, \xtdisputes, \xtpreimages, \xtassurances, \xtguarantees)\end{aligned}$$

The header is a collection of metadata primarily concerned with cryptographic references to the blockchain ancestors and the operands and result of the present transition. As an immutable known *a priori*, it is assumed to be available throughout the functional components of block transition. The extrinsic data is split into its several portions:

tickets

:   Tickets, used for the mechanism which manages the selection of validators for the permissioning of block authoring. This component is denoted $\xttickets$.

judgements

:   Votes, by validators, on dispute(s) arising between them presently taking place. This is denoted $\xtdisputes$.

preimages

:   Static data which is presently being requested to be available for workloads to be able to fetch on demand. This is denoted $\xtpreimages$.

availability

:   Assurances by each validator concerning which of the input data of workloads they have correctly received and are storing locally. This is denoted $\xtassurances$.

reports

:   Reports of newly completed workloads whose accuracy is guaranteed by specific validators. This is denoted $\xtguarantees$.

## 4.2 The State

Our state may be logically partitioned into several largely independent segments which can both help avoid visual clutter within our protocol description and provide formality over elements of computation which may be simultaneously calculated (i.e. parallelized). We therefore pronounce an equivalence between $\sigma$ (some complete state) and a tuple of partitioned segments of that state: $$\begin{aligned}
\label{eq:statecomposition}
  \sigma &\equiv (\alpha, \beta, \gamma, \delta, \eta, \iota, \kappa, \lambda, \rho, \tau, \varphi, \chi, \psi, \pi)\end{aligned}$$

In summary, $\delta$ is the portion of state dealing with *services*, analogous in JAM to the Yellow Paper's (smart contract) *accounts*, the only state of the *YP*'s Ethereum. The identities of services which hold some privileged status are tracked in $\chi$.

Validators, who are the set of economic actors uniquely privileged to help build and maintain the JAM chain, are identified within $\kappa$, archived in $\lambda$ and enqueued from $\iota$. All other state concerning the determination of these keys is held within $\gamma$. Note this is a departure from the *YP* proof-of-work definitions which were mostly stateless, and this set was not enumerated but rather limited to those with sufficient compute power to find a partial hash-collision in the [sha]{.smallcaps}- cryptographic hash function. An on-chain entropy pool is retained in $\eta$.

Our state also tracks two aspects of each core: $\alpha$, the authorization requirement which work done on that core must satisfy at the time of being reported on-chain, together with the queue which fills this, $\varphi$; and $\rho$, each of the cores' currently assigned *report*, the availability of whose *work-package* must yet be assured by a super-majority of validators.

Finally, details of the most recent blocks and time are tracked in $\beta$ and $\tau$ respectively and, judgements are tracked in $\psi$ and validator statistics are tracked in $\pi$.

### 4.2.1 State Transition Dependency Graph

Much as in the *YP*, we specify $\Upsilon$ as the implication of formulating all items of posterior state in terms of the prior state and block. To aid the architecting of implementations which parallelize this computation, we minimize the depth of the dependency graph where possible. The overall dependency graph is specified here: $$\begin{aligned}
\label{eq:transitionfunctioncomposition}
  \tau' &\prec \mathbf{H} \\
  \beta^\dagger &\prec (\mathbf{H}, \beta) \label{eq:betadagger} \\
  \beta' &\prec (\mathbf{H}, \xtguarantees, \beta^\dagger, \mathbf{C}) \\
  \gamma' &\prec (\mathbf{H}, \tau, \xttickets, \gamma, \iota, \eta', \kappa') \\
  \eta' &\prec (\mathbf{H}, \tau, \eta) \\
  \kappa' &\prec (\mathbf{H}, \tau, \kappa, \gamma, \psi') \\
  \lambda' &\prec (\mathbf{H}, \tau, \lambda, \kappa) \\
  \psi' &\prec (\xtdisputes, \psi) \\
  \delta^\dagger &\prec (\xtpreimages, \delta, \tau') \label{eq:deltadagger} \\
  \rho^\dagger &\prec (\xtdisputes, \rho) \label{eq:rhodagger} \\
  \rho^\ddagger &\prec (\xtassurances, \rho^\dagger) \label{eq:rhoddagger} \\
  \rho' &\prec (\xtguarantees, \rho^\ddagger, \kappa, \tau') \\
  \begin{rcases*}
    \delta' \\
    \chi' \\
    \iota' \\
    \varphi' \\
    \mathbf{C}
  \end{rcases*} &\prec (\xtassurances, \rho', \delta^\dagger, \chi, \iota, \varphi) \\
  \alpha' &\prec (\mathbf{H}, \xtguarantees, \varphi', \alpha) \\
  \pi' &\prec (\xtguarantees, \xtpreimages, \xtassurances, \xttickets, \tau, \kappa', \pi, \mathbf{H})\end{aligned}$$

The only synchronous entanglements are visible through the intermediate components superscripted with a dagger and defined in equations [\[eq:betadagger\]](#eq:betadagger){reference-type="ref" reference="eq:betadagger"}, [\[eq:deltadagger\]](#eq:deltadagger){reference-type="ref" reference="eq:deltadagger"} and [\[eq:rhoddagger\]](#eq:rhoddagger){reference-type="ref" reference="eq:rhoddagger"}. The latter two mark a merge and join in the dependency graph and, concretely, imply that the preimage lookup extrinsic must be folded into state before the availability extrinsic may be fully processed and accumulation of work happen.

## 4.3 Which History?

A blockchain is a sequence of blocks, each cryptographically referencing some prior block by including a hash of its header, all the way back to some first block which references the genesis header. We already presume consensus over this genesis header $\mathbf{H}^0$ and the state it represents already defined as $\sigma^0$.

By defining a deterministic function for deriving a single posterior state for any (valid) combination of prior state and block, we are able to define a unique *canonical* state for any given block. We generally call the block with the most ancestors the *head* and its state the *head state*.

It is generally possible for two blocks to be valid and yet reference the same prior block in what is known as a *fork*. This implies the possibility of two different heads, each with their own state. While we know of no way to strictly preclude this possibility, for the system to be useful we must nonetheless attempt to minimize it. We therefore strive to ensure that:

1.  []{#enum:wh:minimize label="enum:wh:minimize"} It be generally unlikely for two heads to form.

2.  []{#enum:wh:resolve label="enum:wh:resolve"} When two heads do form they be quickly resolved into a single head.

3.  []{#enum:wh:finalize label="enum:wh:finalize"} It be possible to identify a block not much older than the head which we can be extremely confident will form part of the blockchain's history in perpetuity. When a block becomes identified as such we call it *finalized* and this property naturally extends to all of its ancestor blocks.

These goals are achieved through a combination of two consensus mechanisms: *Safrole*, which governs the (not-necessarily forkless) extension of the blockchain; and *Grandpa*, which governs the finalization of some extension into canonical history. Thus, the former delivers point [\[enum:wh:minimize\]](#enum:wh:minimize){reference-type="ref" reference="enum:wh:minimize"}, the latter delivers point [\[enum:wh:finalize\]](#enum:wh:finalize){reference-type="ref" reference="enum:wh:finalize"} and both are important for delivering point [\[enum:wh:resolve\]](#enum:wh:resolve){reference-type="ref" reference="enum:wh:resolve"}. We describe these portions of the protocol in detail in sections [6](#sec:blockproduction){reference-type="ref" reference="sec:blockproduction"} and [\[sec:grandpa\]](#sec:grandpa){reference-type="ref" reference="sec:grandpa"} respectively.

While Safrole limits forks to a large extent (through cryptography, economics and common-time, below), there may be times when we wish to intentionally fork since we have come to know that a particular chain extension must be reverted. In regular operation this should never happen, however we cannot discount the possibility of malicious or malfunctioning nodes. We therefore define such an extension as any which contains a block in which data is reported which *any other* block's state has tagged as invalid (see section [10](#sec:disputes){reference-type="ref" reference="sec:disputes"} on how this is done). We further require that Grandpa not finalize any extension which contains such a block. See section [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"} for more information here.

## 4.4 Time {#sec:commonera}

We presume a pre-existing consensus over time specifically for block production and import. While this was not an assumption of Polkadot, pragmatic and resilient solutions exist including the [ntp]{.smallcaps} protocol and network. We utilize this assumption in only one way: we require that blocks be considered temporarily invalid if their timeslot is in the future. This is specified in detail in section [6](#sec:blockproduction){reference-type="ref" reference="sec:blockproduction"}.

Formally, we define the time in terms of seconds passed since the beginning of the JAM*Common Era*, 1200 UTC on January 1, 2024.[^8] Midday CET is selected to ensure that all significant timezones are on the same date at any exact 24-hour multiple from the beginning of the common era. Formally, this value is denoted $\mathcal{T}$.

## 4.5 Best block

Given the recognition of a number of valid blocks, it is necessary to determine which should be treated as the "best" block, by which we mean the most recent block we believe will ultimately be within of all future JAM chains. The simplest and least risky means of doing this would be to inspect the Grandpa finality mechanism which is able to provide a block for which there is a very high degree of confidence it will remain an ancestor to any future chain head.

However, in reducing the risk of the resulting block ultimately not being within the canonical chain, Grandpa will typically return a block some small period older than the most recently authored block. (Existing deployments suggest around 1-2 blocks in the past under regular operation.) There are often circumstances when we may wish to have less latency at the risk of the returned block not ultimately forming a part of the future canonical chain. E.g. we may be in a position of being able to author a block, and we need to decide what its parent should be. Alternatively, we may care to speculate about the most recent state for the purpose of providing information to a downstream application reliant on the state of JAM.

In these cases, we define the best block as the head of the best chain, itself defined in section [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}.

## 4.6 Economics

The present work describes a crypto-economic system, i.e. one combining elements of both cryptography and economics and game theory to deliver a self-sovereign digital service. In order to codify and manipulate economic incentives we define a token which is native to the system, which we will simply call *tokens* in the present work.

A value of tokens is generally referred to as a *balance*, and such a value is said to be a member of the set of balances, $\N_B$, which is exactly equivalent to the set of naturals less than $2^{64}$ (i.e. 64-bit unsigned integers in coding parlance). Formally: $$\begin{aligned}
\label{eq:balance}
  \N_B \equiv \N_{2^{64}}\end{aligned}$$

Though unimportant for the present work, we presume that there be a standard named denomination for $10^{9}$ tokens. This is different to both Ethereum (which uses a denomination of $10^{18}$), Polkadot (which uses a denomination of $10^{10}$) and Polkadot's experimental cousin Kusama (which uses $10^{12}$).

The fact that balances are constrained to being less than $2^{64}$ implies that there may never be more than around $18\times10^{9}$ tokens (each divisible into portions of $10^{-9}$) within JAM. We would expect that the total number of tokens ever issued will be a substantially smaller amount than this.

We further presume that a number of constant *prices* stated in terms of tokens are known. However we leave the specific values to be determined in following work:

::: description
[]{#eq:prices label="eq:prices"}

the additional minimum balance implied for a single item within a mapping.

the additional minimum balance implied for a single octet of data within a mapping.

the minimum balance implied for a service.
:::

## 4.7 The Virtual Machine and Gas {#sec:virtualmachineandgas}

In the present work, we presume the definition of a *Polka Virtual Machine* ([pvm]{.smallcaps}). This virtual machine is based around the [risc-v]{.smallcaps} instruction set architecture, specifically the [rv]{.smallcaps}[em]{.smallcaps} variant, and is the basis for introducing permissionless logic into our state-transition function.

The [pvm]{.smallcaps} is comparable to the [evm]{.smallcaps} defined in the Yellow Paper, but somewhat simpler: the complex instructions for cryptographic operations are missing as are those which deal with environmental interactions. Overall it is far less opinionated since it alters a pre-existing general purpose design, [risc-v]{.smallcaps}, and optimizes it for our needs. This gives us excellent pre-existing tooling, since [pvm]{.smallcaps} remains essentially compatible with [risc-v]{.smallcaps}, including support from the compiler toolkit [llvm]{.smallcaps} and languages such as Rust and C++. Furthermore, the instruction set simplicity which [risc-v]{.smallcaps} and [pvm]{.smallcaps} share, together with the register size (32-bit), active number (13) and endianness (little) make it especially well-suited for creating efficient recompilers on to common hardware architectures.

The [pvm]{.smallcaps} is fully defined in appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}, but for contextualization we will briefly summarize the basic invocation function $\Psi$ which computes the resultant state of a [pvm]{.smallcaps} instance initialized with some registers ($\lseq\N_R\rseq_{13}$) and [ram]{.smallcaps} ($\mathbb{M}$) and has executed for up to some amount of gas ($\N_G$), a number of approximately time-proportional computational steps: $$\Psi\colon
  \tuple{\,
    \begin{alignedat}{3}
      &\Y\ts\ \ \N_R\ts\ \ &&\N_G\ts\\
      &\!\lseq\N_R\rseq_{13}\ts\ \ &&\mathbb{M}\\
    \end{alignedat}
  \,}
  \to
  \tuple{\,
    \begin{aligned}
      &\{\halt, \panic, \oog\} \cup \{\fault,\host\} \times \N_R,\\
      &\N_R,\ \ \Z_G,\ \ \seq{\N_R}_{13},\ \ \mathbb{M}
    \end{aligned}
  \,}$$

We refer to the time-proportional computational steps as *gas* (much like in the *YP*) and limit it to a 64-bit quantity. We may use either $\N_G$ or $\Z_G$ to bound it, the first as a prior argument since it is known to be positive, the latter as a result where a negative value indicates an attempt to execute beyond the gas limit. Within the context of the [pvm]{.smallcaps}, $\xi \in \N_G$ is typically used to denote gas. $$\label{eq:gasregentry}
  \Z_G \equiv \mathbb{Z}_{-2^{63}\dots2^{63}}\ ,\quad
  \N_G \equiv \mathbb{N}_{2^{64}}\ ,\quad
  \N_R \equiv \N_{2^{32}}$$

It is left as a rather important implementation detail to ensure that the amount of time taken while computing the function $\Psi(\dots, \xi, \dots)$ has a maximum computation time approximately proportional to the value of $\xi$ regardless of other operands.

The [pvm]{.smallcaps} is a very simple [risc]{.smallcaps} *register machine* and as such has 13 registers, each of which is a 32-bit quantity, denoted as $\N_R$, a natural less than $2^{32}$.[^9] Within the context of the [pvm]{.smallcaps}, $\omega \in \seq{\N_R}_{13}$ is typically used to denote the registers. $$\begin{aligned}
  \mathbb{M} &\equiv \ltuple\isa{\mathbf{V}}{\Y_{2^{32}}}\ts\isa{\mathbf{A}}{\lseq\{\text{W}, \text{R}, \none\}\rseq_{2^{32}}}\rtuple\end{aligned}$$

The [pvm]{.smallcaps} assumes a simple pageable [ram]{.smallcaps} of 32-bit addressable octets where each octet may be either immutable, mutable or inaccessible. The [ram]{.smallcaps} definition $\mathbb{M}$ includes two components: a value $\mathbf{V}$ and access $\mathbf{A}$. If the component is unspecified while being subscripted then the value component may be assumed. Within the context of the virtual machine, $\mu \in \mathbb{M}$ is typically used to denote [ram]{.smallcaps}. $$\begin{aligned}
  \mathbb{V}_{\mu} \equiv \{i \mid \mu_\mathbf{A}[i] \ne \none \} \qquad
  \mathbb{V}^*_{\mu} \equiv \{i \mid \mu_\mathbf{A}[i] = \text{W} \}\end{aligned}$$

We define two sets of indices for the [ram]{.smallcaps} $\mu$: $\mathbb{V}_{\mu}$ is the set of indices which may be read from; and $\mathbb{V}^*_{\mu}$ is the set of indices which may be written to.

Invocation of the [pvm]{.smallcaps} has an exit-reason as the first item in the resultant tuple. It is either:

-   Regular program termination caused by an explicit halt instruction, $\halt$.

-   Irregular program termination caused by some exceptional circumstance, $\panic$.

-   Exhaustion of gas, $\oog$.

-   A page fault (attempt to access some address in [ram]{.smallcaps} which is not accessible), $\fault$. This includes the address at fault.

-   An attempt at progressing a host-call, $\host$. This allows for the progression and integration of a context-dependent state-machine beyond the regular [pvm]{.smallcaps}.

The full definition follows in appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

## 4.8 Epochs and Slots {#sec:epochsandslots}

Unlike the *YP* Ethereum with its proof-of-work consensus system, JAM defines a proof-of-authority consensus mechanism, with the authorized validators presumed to be identified by a set of public keys and decided by a *staking* mechanism residing within some system hosted by JAM. The staking system is out of scope for the present work; instead there is an [api]{.smallcaps} which may be utilized to update these keys, and we presume that whatever logic is needed for the staking system will be introduced and utilize this [api]{.smallcaps} as needed.

The Safrole mechanism subdivides time following genesis into fixed length *epoch*s with each epoch divided into $\mathsf{E} = 600$ time*slot*s each of uniform length $\mathsf{P} = 6$ seconds, given an epoch period of $\mathsf{E}\cdot\mathsf{P} = 3600$ seconds or one hour.

This six-second slot period represents the minimum time between JAM blocks, and through Safrole we aim to strictly minimize forks arising both due to contention within a slot (where two valid blocks may be produced within the same six-second period) and due to contention over multiple slots (where two valid blocks are produced in different time slots but with the same parent).

Formally when identifying a timeslot index, we use a natural less than $2^{32}$ (in compute parlance, a 32-bit unsigned integer) indicating the number of six-second timeslots from the JAM Common Era. For use in this context we introduce the set $\N_T$: $$\begin{aligned}
\label{eq:time}
  \N_T \equiv \N_{2^{32}}\end{aligned}$$

This implies that the lifespan of the proposed protocol takes us to mid-August of the year 2840, which with the current course that humanity is on should be ample.

## 4.9 The Core Model and Services {#sec:coremodelandservices}

Whereas in the Ethereum Yellow Paper when defining the state machine which is held in consensus amongst all network participants, we presume that all machines maintaining the full network state and contributing to its enlargement---or, at least, hoping to---evaluate all computation. This "everybody does everything" approach might be called the *on-chain consensus model*. It is unfortunately not scalable, since the network can only process as much logic in consensus that it could hope any individual node is capable of doing itself within any given period of time.

### 4.9.1 In-core Consensus

In the present work, we achieve scalability of the work done through introducing a second model for such computation which we call the *in-core consensus model*. In this model, and under normal circumstances, only a subset of the network is responsible for actually executing any given computation and assuring the availability of any input data it relies upon to others. By doing this and assuming a certain amount of computational parallelism within the validator nodes of the network, we are able to scale the amount of computation done in consensus commensurate with the size of the network, and not with the computational power of any single machine. In the present work we expect the network to be able to do upwards of 300 times the amount of computation *in-core* as that which could be performed by a single machine running the virtual machine at full speed.

Since in-core consensus is not evaluated or verified by all nodes on the network, we must find other ways to become adequately confident that the results of the computation are correct, and any data used in determining this is available for a practical period of time. We do this through a crypto-economic game of three stages called *guaranteeing*, *assuring*, *auditing* and, potentially, *judging*. Respectively, these attach a substantial economic cost to the invalidity of some proposed computation; then a sufficient degree of confidence that the inputs of the computation will be available for some period of time; and finally, a sufficient degree of confidence that the validity of the computation (and thus enforcement of the first guarantee) will be checked by some party who we can expect to be honest.

All execution done in-core must be reproducible by any node synchronized to the portion of the chain which has been finalized. Execution done in-core is therefore designed to be as stateless as possible. The requirements for doing it include only the refinement code of the service, the code of the authorizer and any preimage lookups it carried out during its execution.

When a work-report is presented on-chain, a specific block known as the *lookup-anchor* is identified. Correct behavior requires that this must be in the finalized chain and reasonably recent, both properties which may be proven and thus are acceptable for use within a consensus protocol.

We describe this pipeline in detail in the relevant sections later.

### 4.9.2 On Services and Accounts

In *YP* Ethereum, we have two kinds of accounts: *contract accounts* (whose actions are defined deterministically based on the account's associated code and state) and *simple accounts* which act as gateways for data to arrive into the world state and are controlled by knowledge of some secret key. In JAM, all accounts are *service accounts*. Like Ethereum's contract accounts, they have an associated balance, some code and state. Since they are not controlled by a secret key, they do not need a nonce.

The question then arises: how can external data be fed into the world state of JAM? And, by extension, how does overall payment happen if not by deducting the account balances of those who sign transactions? The answer to the first lies in the fact that our service definition actually includes *multiple* code entry-points, one concerning *refinement* and the other concerning *accumulation*. The former acts as a sort of high-performance stateless processor, able to accept arbitrary input data and distill it into some much smaller amount of output data. The latter code is more stateful, providing access to certain on-chain functionality including the possibility of transferring balance and invoking the execution of code in other services. Being stateful this might be said to more closely correspond to the code of an Ethereum contract account.

To understand how JAM breaks up its service code is to understand JAM's fundamental proposition of generality and scalability. All data extrinsic to JAM is fed into the refinement code of some service. This code is not executed *on-chain* but rather is said to be executed *in-core*. Thus, whereas the accumulator code is subject to the same scalability constraints as Ethereum's contract accounts, refinement code is executed off-chain and subject to no such constraints, enabling JAM services to scale dramatically both in the size of their inputs and in the complexity of their computation.

While refinement and accumulation take place in consensus environments of a different nature, both are executed by the members of the same validator set. The JAM protocol through its rewards and penalties ensures that code executed *in-core* has a comparable level of crypto-economic security to that executed *on-chain*, leaving the primary difference between them one of scalability versus synchroneity.

As for managing payment, JAM introduces a new abstraction mechanism based around Polkadot's Agile Coretime. Within the Ethereum transactive model, the mechanism of account authorization is somewhat combined with the mechanism of purchasing blockspace, both relying on a cryptographic signature to identify a single "transactor" account. In JAM, these are separated and there is no such concept of a "transactor".

In place of Ethereum's gas model for purchasing and measuring blockspace, JAM has the concept of *coretime*, which is prepurchased and assigned to an authorization agent. Coretime is analogous to gas insofar as it is the underlying resource which is being consumed when utilizing JAM. Its procurement is out of scope in the present work and is expected to be managed by a system parachain operating within a parachains service itself blessed with a number of cores for running such system services. The authorization agent allows external actors to provide input to a service without necessarily needing to identify themselves as with Ethereum's transaction signatures. They are discussed in detail in section [8](#sec:authorization){reference-type="ref" reference="sec:authorization"}.

# 5 The Header {#sec:header}

We must first define the header in terms of its components. The header comprises a parent hash and prior state root ($\mathbf{H}_p$ and $\mathbf{H}_r$), an extrinsic hash $\mathbf{H}_x$, a time-slot index $\mathbf{H}_t$, the epoch, winning-tickets and offenders markers $\mathbf{H}_e$, $\mathbf{H}_w$ and $\mathbf{H}_o$, a Bandersnatch block author index $\mathbf{H}_i$ and two Bandersnatch signatures; the entropy-yielding [vrf]{.smallcaps} signature $\mathbf{H}_v$ and a block seal $\mathbf{H}_s$. Headers may be serialized to an octet sequence with and without the latter seal component using $\mathcal{E}$ and $\mathcal{E}_U$ respectively. Formally: $$\label{eq:header}
  \mathbf{H} \equiv (\mathbf{H}_p, \mathbf{H}_r, \mathbf{H}_x, \mathbf{H}_t, \mathbf{H}_e, \mathbf{H}_w, \mathbf{H}_o, \mathbf{H}_i, \mathbf{H}_v, \mathbf{H}_s)$$

Blocks considered invalid by this rule may become valid as $\mathcal{T}$ advances.

The blockchain is a sequence of blocks, each cryptographically referencing some prior block by including a hash derived from the parent's header, all the way back to some first block which references the genesis header. We already presume consensus over this genesis header $\mathbf{H}^0$ and the state it represents defined as $\sigma^0$.

Excepting the Genesis header, all block headers $\mathbf{H}$ have an associated parent header, whose hash is $\mathbf{H}_p$. We denote the parent header $\mathbf{H}^- = P(\mathbf{H})$: $$\mathbf{H}_p \in \H \,,\quad \mathbf{H}_p \equiv \mathcal{H}(\se(P(\mathbf{H})))$$

$P$ is thus defined as being the mapping from one block header to its parent block header. With $P$, we are able to define the set of ancestor headers $\mathbf{A}$: $$\begin{aligned}
\label{eq:ancestors}
  h \in \mathbf{A} \Leftrightarrow h = \mathbf{H} \vee (\exists i \in \mathbf{A} : h = P(i))\end{aligned}$$

We only require implementations to store headers of ancestors which were authored in the previous $\mathsf{L} =$ 24 hours of any block $\mathbf{B}$ they wish to validate.

The extrinsic hash is the hash of the block's extrinsic data. Given any block $\mathbf{B} = (\mathbf{H}, \mathbf{E})$, then formally: $$\mathbf{H}_x \in \H \,,\quad \mathbf{H}_x \equiv \mathcal{H}(\mathcal{E}(\mathbf{E}))$$

A block may only be regarded as valid once the time-slot index $\mathbf{H}_t$ is in the past. It is always strictly greater than that of its parent. Formally: $$\mathbf{H}_t \in \N_T \,,\quad
  P(\mathbf{H})_t < \mathbf{H}_t\ \wedge\ \mathbf{H}_t\cdot\mathsf{P} \leq \mathcal{T}$$

The parent state root $\mathbf{H}_r$ is the root of a Merkle trie composed by the mapping of the *prior* state's Merkle root, which by definition is also the parent block's posterior state. This is a departure from both Polkadot and the Yellow Paper's Ethereum, in both of which a block's header contains the *posterior* state's Merkle root. We do this to facilitate the pipelining of block computation and in particular of Merklization. $$\mathbf{H}_r \in \H \,,\quad \mathbf{H}_r \equiv \mathcal{M}_\sigma(\sigma)$$

We assume the state-Merklization function $\mathcal{M}_\sigma$ is capable of transforming our state $\sigma$ into a 32-octet commitment. See appendix [27](#sec:statemerklization){reference-type="ref" reference="sec:statemerklization"} for a full definition of these two functions.

All blocks have an associated public key to identify the author of the block. We identify this as an index into the posterior current validator set $\kappa'$. We denote the Bandersnatch key of the author as $\mathbf{H}_a$ though note that this is merely an equivalence, and is not serialized as part of the header. $$\mathbf{H}_i \in \N_\mathsf{V} \,,\quad \mathbf{H}_a \equiv \kappa'[\mathbf{H}_i]$$

## 5.1 The Markers {#sec:markers}

If not $\none$, then the epoch marker specifies key and entropy relevant to the following epoch in case the ticket contest does not complete adequately (a very much unexpected eventuality). Similarly, the winning-tickets marker, if not $\none$, provides the series of 600 slot sealing "tickets" for the next epoch (see the next section). Finally, the offenders marker is the sequence of Ed25519 keys of newly misbehaving validators, to be fully explained in section [10](#sec:disputes){reference-type="ref" reference="sec:disputes"}. Formally: $$\mathbf{H}_e \in \tuple{\H\ts\lseq\H_B\rseq_{\mathsf{V}}}\bm{?}\,,\quad
  \mathbf{H}_w \in \seq{\mathbb{C}} _{\mathsf{E}}\bm{?}\,,\quad
  \mathbf{H}_o \in \seq{\H_E}$$

The terms are fully defined in sections [6.6](#sec:epochmarker){reference-type="ref" reference="sec:epochmarker"} and [10](#sec:disputes){reference-type="ref" reference="sec:disputes"}.

# 6 Block Production and Chain Growth {#sec:blockproduction}

As mentioned earlier, JAM is architected around a hybrid consensus mechanism, similar in nature to that of Polkadot's [Babe]{.smallcaps}/[Grandpa]{.smallcaps} hybrid. JAM's block production mechanism, termed Safrole after the novel Sassafras production mechanism of which it is a simplified variant, is a stateful system rather more complex than the Nakamoto consensus described in the *YP*.

The chief purpose of a block production consensus mechanism is to limit the rate at which new blocks may be authored and, ideally, preclude the possibility of "forks": multiple blocks with equal numbers of ancestors.

To achieve this, Safrole limits the possible author of any block within any given six-second timeslot to a single key-holder from within a prespecified set of *validators*. Furthermore, under normal operation, the identity of the key-holder of any future timeslot will have a very high degree of anonymity. As a side effect of its operation, we can generate a high-quality pool of entropy which may be used by other parts of the protocol and is accessible to services running on it.

Because of its tightly scoped role, the core of Safrole's state, $\gamma$, is independent of the rest of the protocol. It interacts with other portions of the protocol through $\iota$ and $\kappa$, the prospective and active sets of validator keys respectively; $\tau$, the most recent block's timeslot; and $\eta$, the entropy accumulator.

The Safrole protocol generates, once per epoch, a sequence of $\mathsf{E}$ *sealing keys*, one for each potential block within a whole epoch. Each block header includes its timeslot index $\mathbf{H}_t$ (the number of six-second periods since the JAM Common Era began) and a valid seal signature $\mathbf{H}_s$, signed by the sealing key corresponding to the timeslot within the aforementioned sequence. Each sealing key is in fact a pseudonym for some validator which was agreed the privilege of authoring a block in the corresponding timeslot.

In order to generate this sequence of sealing keys in regular operation, and in particular to do so without making public the correspondence relation between them and the validator set, we use a novel cryptographic structure known as a Ring[vrf]{.smallcaps}, utilizing the Bandersnatch curve. Bandersnatch Ring[vrf]{.smallcaps} allows for a proof to be provided which simultaneously guarantees the author controlled a key within a set (in our case validators), and secondly provides an output, an unbiasable deterministic hash giving us a secure verifiable random function ([vrf]{.smallcaps}). This anonymous and secure random output is a *ticket* and validators' tickets with the best score define the new sealing keys allowing the chosen validators to exercise their privilege and create a new block at the appropriate time.

## 6.1 Timekeeping {#sec:timekeeping}

Here, $\tau$ defines the most recent block's slot index, which we transition to the slot index as defined in the block's header: $$\label{eq:timeslotindex}
  \tau \in \N_T \ ,\quad
  \tau' \equiv \mathbf{H}_t$$

We track the slot index in state as $\tau$ in order that we are able to easily both identify a new epoch and determine the slot at which the prior block was authored. We denote $e$ as the prior's epoch index and $m$ as the prior's slot phase index within that epoch and $e'$ and $m'$ are the corresponding values for the present block: $$\begin{aligned}
  \mathrm{let}\quad e \remainder m = \frac{\tau}{\mathsf{{}E}} \,,\quad
  e' \remainder m' = \frac{\tau'}{\mathsf{{}E}}\end{aligned}$$

## 6.2 Safrole Basic State {#sec:safrolebasicstate}

We restate $\gamma$ into a number of components: $$\begin{aligned}
\label{eq:consensusstatecomposition}
  \gamma &\equiv \tuple{\gamma_\mathbf{k}\ts\gamma_z\ts\gamma_\mathbf{s}\ts\gamma_\mathbf{a}}\end{aligned}$$

$\gamma_z$ is the epoch's root, a Bandersnatch ring root composed with the one Bandersnatch key of each of the next epoch's validators, defined in $\gamma_\mathbf{k}$ (itself defined in the next section). $$\begin{aligned}
  \gamma_z &\in \Y_R\end{aligned}$$

Finally, $\gamma_\mathbf{a}$ is the ticket accumulator, a series of highest-scoring ticket identifiers to be used for the next epoch. $\gamma_\mathbf{s}$ is the current epoch's slot-sealer series, which is either a full complement of $\mathsf{E}$ tickets or, in the case of a fallback mode, a series of $\mathsf{E}$ Bandersnatch keys: $$\begin{aligned}
  \gamma_\mathbf{a} \in \lseq \mathbb{C} \rseq_{:\mathsf{E}} \,,\quad
  \gamma_\mathbf{s} \in \lseq \mathbb{C} \rseq_{\mathsf{E}} \cup \seq{\H_B}_\mathsf{E}\end{aligned}$$

Here, $\mathbb{C}$ is used to denote the set of *tickets*, a combination of a verifiably random ticket identifier $\mathbf{y}$ and the ticket's entry-index $r$: $$\begin{aligned}
\label{eq:ticket}
  \mathbb{C} &\equiv \ltuple\isa{\mathbf{y}}{\H}\ts\isa{r}{\N_\mathsf{N}}\rtuple\end{aligned}$$

As we state in section [6.4](#sec:sealandentropy){reference-type="ref" reference="sec:sealandentropy"}, Safrole requires that every block header $\mathbf{H}$ contain a valid seal $\mathbf{H}_s$, which is a Bandersnatch signature for a public key at the appropriate index $m$ of the current epoch's seal-key series, present in state as $\gamma_\mathbf{s}$.

## 6.3 Key Rotation {#sec:keyrotation}

In addition to the active set of validator keys $\kappa$ and staging set $\iota$, internal to the Safrole state we retain a pending set $\gamma_\mathbf{k}$. The active set is the set of keys identifying the nodes which are currently privileged to author blocks and carry out the validation processes, whereas the pending set $\gamma_\mathbf{k}$, which is reset to $\iota$ at the beginning of each epoch, is the set of keys which will be active in the next epoch and which determine the Bandersnatch ring root which authorizes tickets into the sealing-key contest for the next epoch. $$\begin{aligned}
\label{eq:validatorkeys}
  \iota \in \seq{\mathbb{K}}_{\mathsf{V}} \;,\quad
  \gamma_\mathbf{k} \in \seq{\mathbb{K}}_{\mathsf{V}} \;,\quad
  \kappa \in \seq{\mathbb{K}}_{\mathsf{V}} \;,\quad
  \lambda \in \seq{\mathbb{K}}_{\mathsf{V}}\end{aligned}$$

We must introduce $\mathbb{K}$, the set of validator key tuples. This is a combination of a set of cryptographic public keys and metadata which is an opaque octet sequence, but utilized to specify practical identifiers for the validator, not least a hardware address.

The set of validator keys itself is equivalent to the set of 336-octet sequences. However, for clarity, we divide the sequence into four easily denoted components. For any validator key $k$, the Bandersnatch key is denoted $k_b$, and is equivalent to the first 32-octets; the Ed25519 key, $k_e$, is the second 32 octets; the [bls]{.smallcaps} key denoted $k_{BLS}$ is equivalent to the following 144 octets, and finally the metadata $k_m$ is the last 128 octets. Formally: $$\begin{aligned}
  \mathbb{K} &\equiv \mathbb{Y}_{336} \\
  \forall k \in \mathbb{K} : k_b \in \H_B &\equiv k_{0\dots+32} \\
  \forall k \in \mathbb{K} : k_e \in \H_E &\equiv k_{32\dots+32} \\
  \forall k \in \mathbb{K} : k_{BLS} \in \Y_{BLS} &\equiv k_{64\dots+144} \\
  \forall k \in \mathbb{K} : k_m \in \Y_{128} &\equiv k_{208\dots+128}\end{aligned}$$

With a new epoch under regular conditions, validator keys get rotated and the epoch's Bandersnatch key root is updated into $\gamma'_z$: $$\begin{aligned}
  (\gamma'_\mathbf{k}, \kappa', \lambda', \gamma'_z) &\equiv \begin{cases}
    (\Phi(\iota), \gamma_\mathbf{k}, \kappa, z) &\when e' > e \\ (\gamma_\mathbf{k}, \kappa, \lambda, \gamma_z) &\otherwise
  \end{cases} \\
  \nonumber \where z &= \mathcal{O}([k_b \mid k \orderedin \gamma'_\mathbf{k}]) \\
  \label{eq:blacklistfilter} \Phi(\mathbf{k}) &\equiv \sq{
    \begin{rcases}[0, 0, \dots] &\when k_e \in \offenders' \\ k &\otherwise \end{rcases}
    \,\middle\mid\, k \orderedin \mathbf{k}
  }\end{aligned}$$

Note that on epoch changes the posterior queued validator key set $\gamma'_k$ is defined such that incoming keys belonging to the offenders $\offenders'$ are replaced with a null key containing only zeroes. The origin of the offenders is explained in section [10](#sec:disputes){reference-type="ref" reference="sec:disputes"}.

## 6.4 Sealing and Entropy Accumulation {#sec:sealandentropy}

The header must contain a valid seal and valid [vrf]{.smallcaps} output. These are two signatures both using the current slot's seal key; the message data of the former is the header's serialization omitting the seal component $\mathbf{H}_s$, whereas the latter is used as a bias-resistant entropy source and thus its message must already have been fixed: we use the entropy stemming from the [vrf]{.smallcaps} of the seal signature. Formally: $$\begin{aligned}
    \nonumber \using i = \gamma'_\mathbf{s}[\mathbf{H}_t]^\circlearrowleft\colon \\
    \label{eq:ticketconditiontrue}
    \gamma'_\mathbf{s} \in \seq{\mathbb{C}} &\implies \left\{\,\begin{aligned}
        &i_\mathbf{y} = \banderout{\mathbf{H}_s}\,,\\
        &\mathbf{H}_s \in \bandersig{\mathbf{H}_a}{\mathsf{X}_T \concat \eta_3 \doubleplus i_r}{\mathcal{E}_U(\mathbf{H})}\,,\\
        &\mathbf{T} = 1
    \end{aligned}\right.\\
    \label{eq:ticketconditionfalse}
    \gamma'_\mathbf{s} \in \seq{\H_B} &\implies \left\{\,\begin{aligned}
        &i = \mathbf{H}_a\,,\\
        &\mathbf{H}_s \in \bandersig{\mathbf{H}_a}{\mathsf{X}_F \concat \eta_3}{\mathcal{E}_U(\mathbf{H})}\,,\\
        &\mathbf{T} = 0
    \end{aligned}\right.\\
  \mathbf{H}_v &\in \bandersig{\mathbf{H}_a}{\mathsf{X}_E\frown \banderout{\mathbf{H}_s}}{[]} \\
  \mathsf{X}_E &= \token{\$jam\_entropy}\\
  \mathsf{X}_F &= \token{\$jam\_fallback\_seal}\\
  \mathsf{X}_T &= \token{\$jam\_ticket\_seal}
  \end{aligned}$$

Sealing using the ticket is of greater security, and we utilize this knowledge when determining a candidate block on which to extend the chain, detailed in section [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}. We thus note that the block was sealed under the regular security with the boolean marker $\mathbf{T}$. We define this only for the purpose of ease of later specification.

In addition to the entropy accumulator $\eta_0$, we retain three additional historical values of the accumulator at the point of each of the three most recently ended epochs, $\eta_1$, $\eta_2$ and $\eta_3$. The second-oldest of these $\eta_2$ is utilized to help ensure future entropy is unbiased (see equation [\[eq:ticketsextrinsic\]](#eq:ticketsextrinsic){reference-type="ref" reference="eq:ticketsextrinsic"}) and seed the fallback seal-key generation function with randomness (see equation [\[eq:slotkeysequence\]](#eq:slotkeysequence){reference-type="ref" reference="eq:slotkeysequence"}). The oldest is used to regenerate this randomness when verifying the seal above (see equations [\[eq:ticketconditionfalse\]](#eq:ticketconditionfalse){reference-type="ref" reference="eq:ticketconditionfalse"} and [\[eq:ticketconditiontrue\]](#eq:ticketconditiontrue){reference-type="ref" reference="eq:ticketconditiontrue"}). $$\begin{aligned}
\label{eq:entropycomposition}
  \eta &\in \lseq\H\rseq_4\end{aligned}$$

$\eta_0$ defines the state of the randomness accumulator to which the provably random output of the [vrf]{.smallcaps}, the signature over some unbiasable input, is combined each block. $\eta_1$ and $\eta_2$ meanwhile retain the state of this accumulator at the end of the two most recently ended epochs in order. $$\begin{aligned}
  \eta'_0 &\equiv \mathcal{H}(\eta_0 \frown \banderout{\mathbf{H}_v})\end{aligned}$$

On an epoch transition (identified as the condition $e' > e$), we therefore rotate the accumulator value into the history $\eta_1$, $\eta_2$ and $\eta_3$: $$\begin{aligned}
  (\eta'_1, \eta'_2, \eta'_3) &\equiv \begin{cases}
    (\eta_0, \eta_1, \eta_2) &\when e' > e \\
    (\eta_1, \eta_2, \eta_3) &\otherwise
  \end{cases}\end{aligned}$$

## 6.5 The Slot Key Sequence

The posterior slot key sequence $\gamma'_\mathbf{s}$ is one of three expressions depending on the circumstance of the block. If the block is not the first in an epoch, then it remains unchanged from the prior $\gamma_\mathbf{s}$. If the block signals the next epoch (by epoch index) and the previous block's slot was within the closing period of the previous epoch, then it takes the value of the prior ticket accumulator $\gamma_\mathbf{a}$. Otherwise, it takes the value of the fallback key sequence. Formally: $$\begin{aligned}
\label{eq:slotkeysequence}
  \gamma'_\mathbf{s} &\equiv \begin{cases}
    Z(\gamma_\mathbf{a}) &\when e' = e + 1 \wedge m \geq \mathsf{Y} \wedge |\gamma_\mathbf{a}| = \mathsf{E}\!\!\\
    \gamma_\mathbf{s} &\when e' = e \\
    F(\eta'_2, \kappa') \!\!\!&\otherwise
  \end{cases}\end{aligned}$$

Here, we use $Z$ as the outside-in sequencer function, defined as follows: $$Z\colon\left\{\,\begin{aligned}
    \seq{\mathbb{C}}_\mathsf{E} &\to \seq{\mathbb{C}}_\mathsf{E}\\
    \mathbf{s} &\mapsto [\mathbf{s}_0, \mathbf{s}_{|\mathbf{s}| - 1}, \mathbf{s}_1, \mathbf{s}_{|\mathbf{s}| - 2}, \dots]\\
  \end{aligned}\right.$$

Finally, $F$ is the fallback key sequence function which selects an epoch's worth of validator Bandersnatch keys ($\seq{\mathbb{H}_B}_{\mathsf{E}}$) from the validator key set $\mathbf{k}$ using the entropy collected on-chain $r$: $$\label{eq:fallbackkeysequence}
  F\colon \left\{\ \begin{aligned}
    \tuple{\H \ts \seq{\mathbb{K}}} &\to \seq{\mathbb{H}_B}_{\mathsf{E}}\\
    \tup{r \ts \mathbf{k}} &\mapsto \left[
    \mathbf{k}[\de(\mathcal{H}_4(r \frown \mathcal{E}_4(i)))]^\circlearrowleft_b
    \middle\vert\; i \in \N_\mathsf{E}
    \right]
  \end{aligned} \right.\!\!\!$$

## 6.6 The Markers {#sec:epochmarker}

The epoch and winning-tickets markers are information placed in the header in order to minimize data transfer necessary to determine the validator keys associated with any given epoch. They are particularly useful to nodes which do not synchronize the entire state for any given block since they facilitate the secure tracking of changes to the validator key sets using only the chain of headers.

As mentioned earlier, the header's epoch marker $\mathbf{H}_e$ is either empty or, if the block is the first in a new epoch, then a tuple of the epoch randomness and a sequence of Bandersnatch keys defining the Bandersnatch validator keys ($k_b$) beginning in the next epoch. Formally: $$\begin{aligned}
\label{eq:epochmarker}
  \mathbf{H}_e &\equiv \begin{cases}
    ( \eta'_1, [ k_b \mid k \orderedin \gamma'_\mathbf{k} ] )\qquad\qquad &\when e' > e \\
    \none & \otherwise
  \end{cases}\end{aligned}$$

The winning-tickets marker $\mathbf{H}_w$ is either empty or, if the block is the first after the end of the submission period for tickets and if the ticket accumulator is saturated, then the final sequence of ticket identifiers. Formally: $$\begin{aligned}
\label{eq:winningticketsmarker}
  \mathbf{H}_w &\equiv \begin{cases}
    Z(\gamma_\mathbf{a}) &\when e' = e \wedge m < \mathsf{Y} \le m' \wedge |\gamma_\mathbf{a}| = \mathsf{E} \\
    \none & \otherwise
  \end{cases}\end{aligned}$$

## 6.7 The Extrinsic and Tickets

The extrinsic $\xttickets$ is a sequence of proofs of valid tickets; a ticket implies an entry in our epochal "contest" to determine which validators are privileged to author a block for each timeslot in the following epoch. Tickets specify an entry index together with a proof of ticket's validity. The proof implies a ticket identifier, a high-entropy unbiasable 32-octet sequence, which is used both as a score in the aforementioned contest and as input to the on-chain [vrf]{.smallcaps}.

Towards the end of the epoch (i.e. $\mathsf{Y}$ slots from the start) this contest is closed implying successive blocks within the same epoch must have an empty tickets extrinsic. At this point, the following epoch's seal key sequence becomes fixed.

We define the extrinsic as a sequence of proofs of valid tickets, each of which is a tuple of an entry index (a natural number less than $\mathsf{N}$) and a proof of ticket validity. Formally: $$\begin{aligned}
\label{eq:ticketsextrinsic}
  \xttickets &\in \lseq\ltuple\isa{r}{\N_{\mathsf{N}}}\ts\isa{p}{\bandersnatch{\gamma_z}{\mathsf{X}_T \frown \eta'_2 \doubleplus r}{[]}}\rtuple\rseq \\
  |\xttickets| &\le \begin{cases}
      \mathsf{K} &\when m' < \mathsf{Y} \\
      0 &\otherwise
  \end{cases}\end{aligned}$$

We define $\mathbf{n}$ as the set of new tickets, with the ticket identifier, a hash, defined as the output component of the Bandersnatch Ring[vrf]{.smallcaps} proof: $$\begin{aligned}
  \mathbf{n} &\equiv [\ltup\is{\mathbf{y}}{\banderout{i_p}}\ts\is{r}{i_r}\rtup \mid i \orderedin \xttickets ]\end{aligned}$$

The tickets submitted via the extrinsic must already have been placed in order of their implied identifier. Duplicate identifiers are never allowed lest a validator submit the same ticket multiple times: $$\begin{aligned}
  \mathbf{n} &= \orderuniqby{x_\mathbf{y}}{x \in \mathbf{n}} \\
  \{x_\mathbf{y} \mid x \in \mathbf{n}\} &\disjoint \{x_\mathbf{y} \mid x \in \gamma_\mathbf{a}\}\end{aligned}$$

The new ticket accumulator $\gamma'_\mathbf{a}$ is constructed by merging new tickets into the previous accumulator value (or the empty sequence if it is a new epoch): $$\begin{aligned}
    \gamma'_\mathbf{a} &\equiv {\overrightarrow{\orderby{x_\mathbf{y}}{x \in \mathbf{n} \cup \begin{cases} \varnothing\ &\when e' > e \\ \gamma_\mathbf{a}\ &\otherwise \end{cases}}~}}^\mathsf{E} \\
  \end{aligned}$$

The maximum size of the ticket accumulator is $\mathsf{E}$. On each block, the accumulator becomes the lowest items of the sorted union of tickets from prior accumulator $\gamma_\mathbf{a}$ and the submitted tickets. It is invalid to include useless tickets in the extrinsic, so all submitted tickets must exist in their posterior ticket accumulator. Formally: $$\begin{aligned}
  \mathbf{n} \subseteq \gamma'_\mathbf{a}\end{aligned}$$

Note that it can be shown that in the case of an empty extrinsic $\xttickets = []$, as implied by $m' \ge \mathsf{Y}$, and unchanged epoch ($e' = e$), then $\gamma'_\mathbf{a} = \gamma_\mathbf{a}$.

# 7 Recent History {#sec:recenthistory}

We retain in state information on the most recent $\mathsf{H}$ blocks. This is used to preclude the possibility of duplicate or out of date work-reports from being submitted. $$\beta \in \lseq\ltuple \isa{h}{\H}\ts\isa{\mathbf{b}}{\seq{\H?}}\ts\isa{s}{\H}\ts\isa{\mathbf{p}}{\lseq\H\rseq_{:\mathsf{C}}} \rtuple\rseq_{:\mathsf{H}}$$

For each recent block, we retain its header hash, its state root, its accumulation-result [mmr]{.smallcaps} and the hash of each work-report made into it which is no more than the total number of cores, $\mathsf{C} = 341$.

During the accumulation stage, a value with the partial transition of this state is provided which contains the update for the newly-known roots of the parent block: $$\beta^\dagger \equiv \beta\quad\exc\quad\beta^\dagger[|\beta| - 1]_s = \mathbf{H}_r$$

We define an item $n$ comprising the new block's header hash, its accumulation-result Merkle tree root and the set of work-reports made into it (for which we use the guarantees extrinsic, $\xtguarantees$). Note that the accumulation-result tree root $r$ is derived from $\mathbf{C}$ (defined in section [12](#sec:accumulation){reference-type="ref" reference="sec:accumulation"}) using the basic binary Merklization function $\mathcal{M}_B$ (defined in appendix [28](#sec:merklization){reference-type="ref" reference="sec:merklization"}) and appending it using the [mmr]{.smallcaps} append function $\mathcal{A}$ (defined in appendix [28.2](#sec:mmr){reference-type="ref" reference="sec:mmr"}) to form a Merkle mountain range. $$\begin{aligned}
    \using r &= \mathcal{M}_B(\orderby{s}{\se_4(s)\frown\se(h) \mid (s, h) \in \mathbf{C}}, \mathcal{H}_K) \\
    \using \mathbf{b} &= \mathcal{A}(\text{last}(\sq{\sq{}} \concat \sq{x_\mathbf{b} \mid x \orderedin \beta}), r, \mathcal{H}_K) \\
    \using n &= \tup{
      \is{\mathbf{p}}{[((g_w)_s)_h \mid g \orderedin \xtguarantees]}\ts
      \is{h}{\mathcal{H}(\mathbf{H})}\ts\mathbf{b}\ts\is{s}{\H^0}
      }
    \end{aligned}$$

The state-trie root is as being the zero hash, $\H^0$ which while inaccurate at the end state of the block $\beta'$, it is nevertheless safe since $\beta'$ is not utilized except to define the next block's $\beta^\dagger$, which contains a corrected value for this.

The final state transition is then: $$\beta' \equiv {\overleftarrow{\beta^\dagger \doubleplus n}}^\mathsf{H}$$

# 8 Authorization {#sec:authorization}

We have previously discussed the model of work-packages and services in section [4.9](#sec:coremodelandservices){reference-type="ref" reference="sec:coremodelandservices"}, however we have yet to make a substantial discussion of exactly how some *coretime* resource may be apportioned to some work-package and its associated service. In the *YP* Ethereum model, the underlying resource, gas, is procured at the point of introduction on-chain and the purchaser is always the same agent who authors the data which describes the work to be done (i.e. the transaction). Conversely, in Polkadot the underlying resource, a parachain slot, is procured with a substantial deposit for typically 24 months at a time and the procurer, generally a parachain team, will often have no direct relation to the author of the work to be done (i.e. a parachain block).

On a principle of flexibility, we would wish JAM capable of supporting a range of interaction patterns both Ethereum-style and Polkadot-style. In an effort to do so, we introduce the *authorization system*, a means of disentangling the intention of usage for some coretime from the specification and submission of a particular workload to be executed on it. We are thus able to disassociate the purchase and assignment of coretime from the specific determination of work to be done with it, and so are able to support both Ethereum-style and Polkadot-style interaction patterns.

## 8.1 Authorizers and Authorizations

The authorization system involves two key concepts: *authorizers* and *authorizations*. An authorization is simply a piece of opaque data to be included with a work-package. An authorizer meanwhile, is a piece of pre-parameterized logic which accepts as an additional parameter an authorization and, when executed within a [vm]{.smallcaps} of prespecified computational limits, provides a Boolean output denoting the veracity of said authorization.

Authorizers are identified as the hash of their logic (specified as the [vm]{.smallcaps} code) and their pre-parameterization. The process by which work-packages are determined to be authorized (or not) is not the competence of on-chain logic and happens entirely in-core and as such is discussed in section [14.3](#sec:packagesanditems){reference-type="ref" reference="sec:packagesanditems"}. However, on-chain logic must identify each set of authorizers assigned to each core in order to verify that a work-package is legitimately able to utilize that resource. It is this subsystem we will now define.

## 8.2 Pool and Queue

We define the set of authorizers allowable for a particular core $c$ as the *authorizer pool* $\alpha[c]$. To maintain this value, a further portion of state is tracked for each core: the core's current *authorizer queue* $\varphi[c]$, from which we draw values to fill the pool. Formally: $$\label{eq:authstatecomposition}
  \alpha \in \seq{\seq{\H}_{:\mathsf{O}}}_\mathsf{C}\ , \qquad
  \varphi \in \seq{\seq{\H}_{\mathsf{Q}}}_\mathsf{C}$$

Note: The portion of state $\varphi$ may be altered only through an exogenous call made from the accumulate logic of an appropriately privileged service.

The state transition of a block involves placing a new authorization into the pool from the queue: $$\begin{aligned}
  &\forall c \in \N_\mathsf{C} : \alpha'[c] \equiv {\overleftarrow{F(c) \doubleplus \varphi'[c] [ \mathbf{H}_t ]^{\circlearrowleft}}}^{\mathsf{O}} \\
  &F(c) \equiv \begin{cases} \alpha[c] \seqminusl \{(g_w)_a\} &\when \exists g \in \xtguarantees : (g_w)_c = c \\ \alpha[c] & \otherwise \end{cases}\end{aligned}$$

Since $\alpha'$ is dependent on $\varphi'$, practically speaking, this step must be computed after accumulation, the stage in which $\varphi'$ is defined. Note that we utilize the guarantees extrinsic $\xtguarantees$ to remove the oldest authorizer which has been used to justify a guaranteed work-package in the current block. This is further defined in equation [\[eq:guaranteesextrinsic\]](#eq:guaranteesextrinsic){reference-type="ref" reference="eq:guaranteesextrinsic"}.

# 9 Service Accounts {#sec:accounts}

As we already noted, a service in JAM is somewhat analogous to a smart contract in Ethereum in that it includes amongst other items, a code component, a storage component and a balance. Unlike Ethereum, the code is split over two isolated entry-points each with their own environmental conditions; one, *refinement*, is essentially stateless and happens in-core, and the other, *accumulation*, which is stateful and happens on-chain. It is the latter which we will concern ourselves with now.

Service accounts are held in state under $\delta$, a partial mapping from a service identifier $\N_S$ into a tuple of named elements which specify the attributes of the service relevant to the JAM protocol. Formally: $$\begin{aligned}
\label{eq:serviceaccounts}
  \N_S &\equiv \N_{2^{32}} \\
  \delta &\in \dict{\N_S}{\mathbb{A}}\end{aligned}$$

The service account is defined as the tuple of storage dictionary $\mathbf{s}$, preimage lookup dictionaries $\mathbf{p}$ and $\mathbf{l}$, code hash $c$, and balance $b$ as well as the two code gas limits $g$ & $m$. Formally: $$\begin{aligned}
\label{eq:serviceaccount}
  \mathbb{A} \equiv \ltuple\ \begin{aligned}
  \mathbf{s} &\in \dict{\H}{\Y}\ ,\qquad \mathbf{p} \in \dict{\H}{\Y}\ ,\\
  \mathbf{l} &\in \dict{\ltuple\H\ts\N_L\rtuple}{\seq{\N_T}_{:3}}\ ,\\
  c &\in \H\ ,\quad b \in \N_B\ ,\quad  g \in \N_G\ ,\quad m \in \N_G
\end{aligned}\,\rtuple\end{aligned}$$

Thus, the balance of the service of index $s$ would be denoted $\delta[s]_b$ and the storage item of key $k \in \H$ for that service is written $\delta[s]_\mathbf{s}[k]$.

## 9.1 Code and Gas

The code $c$ of a service account is represented by a hash which, if the service is to be functional, must be present within its preimage lookup (see section [9.2](#sec:lookups){reference-type="ref" reference="sec:lookups"}). We thus define the actual code $\mathbf{c}$: $$\begin{aligned}
  \forall \mathbf{a} \in \mathbb{A} : \mathbf{a}_\mathbf{c} \equiv \begin{cases}
    \mathbf{a}_\mathbf{p}[\mathbf{a}_c] &\when \mathbf{a}_c \in \mathbf{a}_\mathbf{p} \\
    \none &\otherwise
  \end{cases}\end{aligned}$$

There are three entry-points in the code:

0 `refine`

:   Refinement, executed in-core and stateless.[^10]

1 `accumulate`

:   Accumulation, executed on-chain and stateful.

2 `on_transfer`

:   Transfer handler, executed on-chain and stateful.

Whereas the first, executing in-core, is described in more detail in section [14.3](#sec:packagesanditems){reference-type="ref" reference="sec:packagesanditems"}, the latter two are defined in the present section.

As stated in appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}, execution time in the JAM virtual machine is measured deterministically in units of *gas*, represented as a natural number less than $2^{64}$ and formally denoted $\N_G$. We may also use $\Z_G$ to denote the set $\Z_{-2^{63}\dots2^{63}}$ if the quantity may be negative. There are two limits specified in the account, $g$, the minimum gas required in order to execute the *Accumulate* entry-point of the service's code, and $m$, the minimum required for the *On Transfer* entry-point.

## 9.2 Preimage Lookups {#sec:lookups}

In addition to storing data in arbitrary key/value pairs available only on-chain, an account may also solicit data to be made available also in-core, and thus available to the Refine logic of the service's code. State concerning this facility is held under the service's $\mathbf{p}$ and $\mathbf{l}$ components.

There are several differences between preimage-lookups and storage. Firstly, preimage-lookups act as a mapping from a hash to its preimage, whereas general storage maps arbitrary keys to values. Secondly, preimage data is supplied extrinsically, whereas storage data originates as part of the service's accumulation. Thirdly preimage data, once supplied, may not be removed freely; instead it goes through a process of being marked as unavailable, and only after a period of time may it be removed from state. This ensures that historical information on its existence is retained. The final point especially is important since preimage data is designed to be queried in-core, under the Refine logic of the service's code, and thus it is important that the historical availability of the preimage is known.

We begin by reformulating the portion of state concerning our data-lookup system. The purpose of this system is to provide a means of storing static data on-chain such that it may later be made available within the execution of any service code as a function accepting only the hash of the data and its length in octets.

During the on-chain execution of the *Accumulate* function, this is trivial to achieve since there is inherently a state which all validators verifying the block necessarily have complete knowledge of, i.e. $\sigma$. However, for the in-core execution of *Refine*, there is no such state inherently available to all validators; we thus name a historical state, the *lookup anchor* which must be considered recently finalized before the work result may be accumulated hence providing this guarantee.

By retaining historical information on its availability, we become confident that any validator with a recently finalized view of the chain is able to determine whether any given preimage was available at any time within the period where auditing may occur. This ensures confidence that judgements will be deterministic even without consensus on chain state.

Restated, we must be able to define some *historical* lookup function $\Lambda$ which determines whether the preimage of some hash $h$ was available for lookup by some service account $\mathbf{a}$ at some timeslot $t$, and if so, provide its preimage: $$\begin{aligned}
  \Lambda\colon \left\{\ \begin{aligned}
    (\mathbb{A}, \N_{\mathbf{H}_t - C_D\dots\mathbf{H}_t}, \mathbb{H}) &\to \mathbb{Y}\bm{?} \\
    (\mathbf{a}, t, \mathcal{H}(\mathbf{p})) &\mapsto v : v \in \{ \mathbf{p}, \none \}
  \end{aligned}\right.
\end{aligned}$$

This function is defined shortly below in equation [\[eq:historicallookup\]](#eq:historicallookup){reference-type="ref" reference="eq:historicallookup"}.

The preimage lookup for some service of index $s$ is denoted $\delta[s]_\mathbf{p}$ is a dictionary mapping a hash to its corresponding preimage. Additionally, there is metadata associated with the lookup denoted $\delta[s]_\mathbf{l}$ which is a dictionary mapping some hash and presupposed length into historical information.

### 9.2.1 Invariants

The state of the lookup system naturally satisfies a number of invariants. Firstly, any preimage value must correspond to its hash, equation [\[eq:preimageconstraints\]](#eq:preimageconstraints){reference-type="ref" reference="eq:preimageconstraints"}. Secondly, a preimage value being in state implies that its hash and length pair has some associated status, also in equation [\[eq:preimageconstraints\]](#eq:preimageconstraints){reference-type="ref" reference="eq:preimageconstraints"}. Formally: $$\label{eq:preimageconstraints}
  \forall a \in \mathbb{A}, (h \mapsto \mathbf{p}) \in a_\mathbf{p} \Rightarrow
    h = \mathcal{H}(\mathbf{p})\wedge
    \tup{h \ts |\mathbf{p}|} \in \keys{a_\mathbf{l}}$$

### 9.2.2 Semantics

The historical status component $h \in \seq{\N_T}_{:3}$ is a sequence of up to three time slots and the cardinality of this sequence implies one of four modes:

-   $h = []$: The preimage is *requested*, but has not yet been supplied.

-   $h \in \seq{\N_T}_1$: The preimage is *available* and has been from time $h_0$.

-   $h \in \seq{\N_T}_2$: The previously available preimage is now *unavailable* since time $h_1$. It had been available from time $h_0$.

-   $h \in \seq{\N_T}_3$: The preimage is *available* and has been from time $h_2$. It had previously been available from time $h_0$ until time $h_1$.

The historical lookup function $\Lambda$ may now be defined as: $$\begin{aligned}\label{eq:historicallookup}
    &\Lambda\colon (\mathbb{A}, \N_T, \H) \to \Y\bm{?} \\
    &\Lambda(\mathbf{a}, t, h) \equiv \begin{cases}
      \mathbf{a}_\mathbf{p}[h]\!\!\!\! &\when h \in \keys{\mathbf{a}_\mathbf{p}} \wedge I(\mathbf{a}_\mathbf{l}[h, |\mathbf{a}_\mathbf{p}[h]|], t) \!\!\!\!\! \\
      \none &\otherwise
    \end{cases}\\
    &\where I(\mathbf{l}, t) = \begin{cases}
      \bot &\when [] = \mathbf{l} \\
      x \le t &\when [x] = \mathbf{l} \\
      x \le t < y &\when [x, y] = \mathbf{l} \\
      x \le t < y \vee z \le t &\when [x, y, z] = \mathbf{l} \\
    \end{cases}
  \end{aligned}$$

## 9.3 Account Footprint and Threshold Balance

We define the dependent values $i$ and $l$ as the storage footprint of the service, specifically the number of items in storage and the total number of octets used in storage. They are defined purely in terms of the storage map of a service, and it must be assumed that whenever a service's storage is changed, these change also.

Furthermore, as we will see in the account serialization function in section [26](#sec:serialization){reference-type="ref" reference="sec:serialization"}, these are expected to be found explicitly within the Merklized state data. Because of this we make explicit their set.

We may then define a second dependent term $t$, the minimum, or *threshold*, balance needed for any given service account in terms of its storage footprint. $$\begin{aligned}
  \forall a \in \mathcal{V}(\delta):\ \begin{cases}
    a_i \in \N_{2^{32}} &\equiv 2\cdot|\,a_\mathbf{l}\,| + |\,a_\mathbf{s}\,| \\
    a_l \in \N_{2^{64}} &\equiv \sum\limits_{\,(h, z) \in \keys{a_\mathbf{l}}\,} 81 + z \\
    &\phantom{\equiv} + \sum\limits_{x \in \mathcal{V}(a_\mathbf{s})} 32 + |x| \\
    a_t \in \N_B &\equiv \mathsf{B}_S + \mathsf{B}_I \cdot a_i + \mathsf{B}_L \cdot a_l
  \end{cases}\end{aligned}$$

## 9.4 Service Privileges

Up to three services may be recognized as privileged. The portion of state in which this is held is denoted $\chi$ and has three service index components together with a gas limit. The first, $\chi_m$, is the index of the *manager* service which is the service able to effect an alteration of $\chi$ from block to block. The following two, $\chi_a$ and $\chi_v$, are each the indices of services able to alter $\varphi$ and $\iota$ from block to block.

Finally, $\chi_\mathbf{g}$ is a small dictionary containing the indices of services which automatically accumulate in each block together with a basic amount of gas with which each accumulates. Formally: $$\begin{aligned}
  \chi \equiv \tuple{
    \isa{\chi_m}{\N_S} \ts
    \isa{\chi_a}{\N_S} \ts
    \isa{\chi_v}{\N_S} \ts
    \isa{\chi_\mathbf{g}}{\dict{\N_S}{\N_G}}
  }\end{aligned}$$

# 10 Disputes, Verdicts and Judgements {#sec:disputes}

JAM provides a means of recording *judgements*: consequential votes amongst most of the validators over the validity of a *work-report* (a unit of work done within JAM, see section [11](#sec:reporting){reference-type="ref" reference="sec:reporting"}). Such collections of judgements are known as *verdicts*. JAM also provides a means of registering *offenses*, judgements and guarantees which dissent with an established *verdict*. Together these form the *disputes* system.

The registration of a verdict is not expected to happen very often in practice, however it is an important security backstop for removing and banning invalid work-reports from the processing pipeline as well as removing troublesome keys from the validator set where there is consensus over their malfunction. It also helps coordinate nodes to revert chain-extensions containing invalid work-reports and provides a convenient means of aggregating all offending validators for punishment in a higher-level system.

Judgement statements come about naturally as part of the auditing process and are expected to be positive, further affirming the guarantors' assertion that the work-report is valid. In the event of a negative judgement, then all validators audit said work-report and we assume a verdict will be reached. Auditing and guaranteeing are off-chain processes properly described in sections [14](#sec:workpackagesandworkreports){reference-type="ref" reference="sec:workpackagesandworkreports"} and [17](#sec:auditing){reference-type="ref" reference="sec:auditing"}.

A judgement against a report implies that the chain is already reverted to some point prior to the accumulation of said report, usually forking at the block immediately prior to that at which accumulation happened. The specific strategy for chain selection is described fully in section [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}. Authoring a block with a non-positive verdict has the effect of cancelling its imminent accumulation, as can be seen in equation [\[eq:removenonpositive\]](#eq:removenonpositive){reference-type="ref" reference="eq:removenonpositive"}.

Registering a verdict also has the effect of placing a permanent record of the event on-chain and allowing any offending keys to be placed on-chain both immediately or in forthcoming blocks, again for permanent record.

Having a persistent on-chain record of misbehavior is helpful in a number of ways. It provides a very simple means of recognizing the circumstances under which action against a validator must be taken by any higher-level validator-selection logic. Should JAM be used for a public network such as *Polkadot*, this would imply the slashing of the offending validator's stake on the staking parachain.

As mentioned, recording reports found to have a high confidence of invalidity is important to ensure that said reports are not allowed to be resubmitted. Conversely, recording reports found to be valid ensures that additional disputes cannot be raised in the future of the chain.

## 10.1 The State

The *disputes* state includes four items, three of which concern verdicts: a good-set ($\goodset$), a bad-set ($\badset$) and a wonky-set ($\wonkyset$) containing the hashes of all work-reports which were respectively judged to be correct, incorrect or that it appears impossible to judge. The fourth item, the punish-set ($\offenders$), is a set of Ed25519 keys representing validators which were found to have misjudged a work-report. $$\psi \equiv \tup{\goodset, \badset, \wonkyset, \offenders}$$

## 10.2 Extrinsic

The disputes extrinsic, $\xtdisputes$, may contain one or more verdicts $\mathbf{v}$ as a compilation of judgements coming from exactly two-thirds plus one of either the active validator set or the previous epoch's validator set, i.e. the Ed25519 keys of $\kappa$ or $\lambda$. Additionally, it may contain proofs of the misbehavior of one or more validators, either by guaranteeing a work-report found to be invalid (*culprits*, $\mathbf{c}$), or by signing a judgement found to be contradiction to a work-report's validity (*faults*, $\mathbf{f}$). Both are considered a kind of *offense*. Formally: $$\begin{aligned}
    \xtdisputes &\equiv (\mathbf{v}, \mathbf{c}, \mathbf{f}) \\
    \where \mathbf{v}&\in \seq{\tup{\H, \ffrac{\tau}{\mathsf{E}} - \N_2, \seq{\tup{\{\top, \bot\}, \N_{\mathsf{V}}, \mathbb{E}}}_{\floor{\nicefrac{2}{3}\mathsf{V}} + 1}}}\\
    \also \mathbf{c}&\in \seq{\H, \H_E, \mathbb{E}} \,,\quad
    \mathbf{f}\in \seq{\H, \{\top,\bot\}, \H_E, \mathbb{E}}
  \end{aligned}$$

The signatures of all judgements must be valid in terms of one of the two allowed validator key-sets, identified by the verdict's second term which must be either the epoch index of the prior state or one less. Formally: $$\begin{aligned}
  &\begin{aligned}
    &\forall (r, a, \mathbf{j}) \in \mathbf{v}, \forall (v, i, s) \in \mathbf{j} : s \in \sig{\mathbf{k}[i]_e}{\mathsf{X}_v \concat r}\\
    &\quad\where \mathbf{k} = \begin{cases}
      \kappa &\when a = \displaystyle \ffrac{\tau}{\mathsf{E}}\\
      \lambda &\otherwise\\
    \end{cases}
  \end{aligned}\\
  &\mathsf{X}_\top \equiv \text{{\small \texttt{\$jam\_valid}}}\,,\ \mathsf{X}_\bot \equiv \text{{\small \texttt{\$jam\_invalid}}}\end{aligned}$$

Offender signatures must be similarly valid and reference work-reports with judgements and may not report keys which are already in the punish-set: $$\begin{aligned}
  \forall (r, k, s) &\in \mathbf{c}: \bigwedge \left\{
  \begin{aligned}
    &r \in \badset' \,,\\
    &k \in \mathbf{k} \,,\\
    &s \in \sig{k}{\mathsf{X}_G \frown r}
  \end{aligned}\right.\\
  \forall (r, v, k, s) &\in \mathbf{f}: \bigwedge \left\{ \begin{aligned}
    &r \in \badset' \Leftrightarrow r \not\in \goodset' \Leftrightarrow v \,,\\
    &k \in \mathbf{k} \,,\\
    &s \in \sig{k}{\mathsf{X}_v \concat r}\\
  \end{aligned}\right.\\
  \nonumber\where \mathbf{k} &= \{k_e \mid k \in \lambda \cup \kappa\} \setminus \offenders\end{aligned}$$

Verdicts $\mathbf{v}$ must be ordered by report hash. Offender signatures $\mathbf{c}$ and $\mathbf{f}$ must each be ordered by the validator's Ed25519 key. There may be no duplicate report hashes within the extrinsic, nor amongst any past reported hashes. Formally: $$\begin{aligned}
  &\mathbf{v}= \orderuniqby{r}{\tup{r, a, \mathbf{j}} \in \mathbf{v}}\\
  &\mathbf{c}= \orderuniqby{k}{\tup{r, k, s} \in \mathbf{c}} \,,\quad
  \mathbf{f}= \orderuniqby{k}{\tup{r, v, k, s} \in \mathbf{f}}\\
  &\{r \mid \tup{r, a, \mathbf{j}} \in \mathbf{v}\} \disjoint \goodset \cup \badset \cup \wonkyset\end{aligned}$$

The judgements of all verdicts must be ordered by validator index and there may be no duplicates: $$\forall (r, a, \mathbf{j}) \in \mathbf{v}: \mathbf{j} = \orderuniqby{i}{\tup{v, i, s} \in \mathbf{j}}$$

We define $\mathbf{V}$ to derive from the sequence of verdicts introduced in the block's extrinsic, containing only the report hash and the sum of positive judgements. We require this total to be either exactly two-thirds-plus-one, zero or one-third of the validator set indicating, respectively, that the report is good, that it's bad, or that it's wonky.[^11] Formally: $$\begin{aligned}
  \mathbf{V}&\in \seq{\tup{\H, \{0, \floor{\nicefrac{1}{3}\mathsf{V}}, \floor{\nicefrac{2}{3}\mathsf{V}} + 1\}}} \\
  \mathbf{V}&= \sq{\tup{r, \sum_{\tup{v, i, s} \in \mathbf{j}}\!\!\!\! v}\ \middle\mid\ \tup{r, a, \mathbf{j}} \orderedin \mathbf{v}}\end{aligned}$$

There are some constraints placed on the composition of this extrinsic: any verdict containing solely valid judgements implies the same report having at least one valid entry in the faults sequence $\mathbf{f}$. Any verdict containing solely invalid judgements implies the same report having at least two valid entries in the culprits sequence $\mathbf{c}$. Formally: $$\begin{aligned}
  \forall (r, \floor{\nicefrac{2}{3}\mathsf{V}} + 1) \in \mathbf{V}&: \exists (r, \dots) \in \mathbf{f}\\
  \forall (r, 0) \in \mathbf{V}&: |\{(r, \dots) \in \mathbf{c}\}| \ge 2\end{aligned}$$

We clear any work-reports which we judged as uncertain or invalid from their core: $$\label{eq:removenonpositive}
  \forall c \in \N_\mathsf{C} : \rho^\dagger[c] = \begin{cases}
    \none &\!\!\!\!\when \{ (\mathcal{H}(\rho[c]_r), t) \in \mathbf{V}, t < \floor{\nicefrac{2}{3}\mathsf{V}} \} \\
    \rho[c] &\!\!\!\!\otherwise
  \end{cases}\!\!\!\!\!\!\!$$

The state's good-set, bad-set and wonky-set assimilate the hashes of the reports from each verdict. Finally, the punish-set accumulates the keys of any validators who have been found guilty of offending. Formally: $$\begin{aligned}
  \goodset' &\equiv \goodset \cup \{r \mid \tup{r, \floor{\nicefrac{2}{3}\mathsf{V}} + 1} \in \mathbf{V}\} \\
  \badset' &\equiv \badset \cup \{r \mid \tup{r, 0} \in \mathbf{V}\} \\
  \wonkyset' &\equiv \wonkyset \cup \{r \mid \tup{r, \floor{\nicefrac{1}{3}\mathsf{V}}} \in \mathbf{V}\} \\
  \offenders' &\equiv \offenders \cup \{ k \mid (r, k, s) \in \mathbf{c}\}\cup \{ k \mid (r, v, k, s) \in \mathbf{f}\}\end{aligned}$$

## 10.3 Header {#sec:judgementmarker}

The offenders markers must contain exactly the keys of all new offenders, respectively. Formally: $$\begin{aligned}
  \mathbf{H}_o &\equiv \sq{ k \mid (r, k, s) \in \mathbf{c}} \frown \sq{ k \mid (r, v, k, s) \in \mathbf{f}}\end{aligned}$$

# 11 Reporting and Assurance {#sec:reporting}

Reporting and assurance are the two on-chain processes we do to allow the results of in-core computation to make its way into the service state singleton, $\delta$. A *work-package*, which comprises several *work items*, is transformed by validators acting as *guarantors* into its corresponding *work-report*, which similarly comprises several *work outputs* and then presented on-chain within the *guarantees* extrinsic. At this point, the work-package is erasure coded into a multitude of segments and each segment distributed to the associated validator who then attests to its availability through an *assurance* placed on-chain. After enough assurances the work-report is considered *available*, and the work outputs transform the state of their associated service by virtue of accumulation, covered in section [12](#sec:accumulation){reference-type="ref" reference="sec:accumulation"}. The report may also be *timed-out*, implying it may be replaced by another report without accumulation.

From the perspective of the work-report, therefore, the guarantee happens first and the assurance afterwards. However, from the perspective of a block's state-transition, the assurances are best processed first since each core may only have a single work-report pending its package becoming available at a time. Thus, we will first cover the transition arising from processing the availability assurances followed by the work-report guarantees. This synchroneity can be seen formally through the requirement of an intermediate state $\rho^\ddagger$, utilized later in equation [\[eq:reportcoresareunusedortimedout\]](#eq:reportcoresareunusedortimedout){reference-type="ref" reference="eq:reportcoresareunusedortimedout"}.

## 11.1 State

The state of the reporting and availability portion of the protocol is largely contained within $\rho$, which tracks the work-reports which have been reported but are not yet known to be available to a super-majority of validators, together with the time at which each was reported. As mentioned earlier, only one report may be assigned to a core at any given time. Formally: $$\label{eq:reportingstate}
  \rho \in \seq{\tuple{\isa{w}{\mathbb{W}},\isa{t}{\N_T}}\bm{?}}_\mathsf{C}$$

As usual, intermediate and posterior values ($\rho^\dagger$, $\rho^\ddagger$, $\rho'$) are held under the same constraints as the prior value.

### 11.1.1 Work Report {#sec:workreport}

A work-report, of the set $\mathbb{W}$, is defined as a tuple of the work-package specification $s$, the refinement context $x$, and the core-index (i.e. on which the work is done) as well as the authorizer hash $a$ and output $\mathbf{o}$ and finally the results of the evaluation of each of the items in the package $\mathbf{r}$, which is always at least one item and may be no more than $\mathsf{I}$ items. Formally: $$\label{eq:workreport}
  \mathbb{W} \equiv \tuple{
    \isa{s}{\mathbb{S}}\ts
    \isa{x}{\mathbb{X}}\ts
    \isa{c}{\N_\mathsf{C}}\ts
    \isa{a}{\H}\ts
    \isa{\mathbf{o}}{\Y}\ts
    \isa{\mathbf{r}}{\seq{\mathbb{L}}_{1:\mathsf{I}}}
  }$$

The total serialized size of a work-report may be no greater than $\mathsf{W}_R$ bytes: $$\forall w \in \mathbb{W} : |\se(w)| \leq \mathsf{W}_R$$

### 11.1.2 Refinement Context

A *refinement context*, denoted by the set $\mathbb{X}$, describes the context of the chain at the point that the report's corresponding work-package was evaluated. It identifies two historical blocks, the *anchor*, header hash $a$ along with its associated posterior state-root $s$ and posterior [Beefy]{.smallcaps} root $b$; and the *lookup-anchor*, header hash $l$ and of timeslot $t$. Finally, it identifies the hash of an optional prerequisite work-package $p$. Formally: $$\mathbb{X} \equiv \ltuple\,\begin{alignedat}{7}
    \isa{a&}{\H}\ts\quad \isa{&s&}{\H}\ts\quad \isa{&b}{\H}\ts\\
    \isa{l&}{\H}\ts\quad \isa{&t&}{\N_T}\ts\quad \isa{&p}{\H\bm{?}}
  \end{alignedat}\rtuple$$

### 11.1.3 Availability

We define the set of *availability specifications*, $\mathbb{S}$, as the tuple of the work-package's hash $h$, an auditable work bundle length $l$ (see section [14.4.1](#sec:availabiltyspecifier){reference-type="ref" reference="sec:availabiltyspecifier"} for more clarity on what this is), together with an erasure-root $u$ and a segment-root $e$. Work-results include this availability specification in order to ensure they are able to correctly reconstruct and audit the purported ramifications of any reported work-package. Formally: $$\begin{aligned}
  \mathbb{S} &\equiv \tuple{
    \isa{h}{\H}\ts
    \isa{l}{\N_L}\ts
    \isa{u}{\H}\ts
    \isa{e}{\H}
  }\end{aligned}$$

The *erasure-root* ($u$) is the root of a binary Merkle tree which functions as a commitment to all data required for the auditing of the report and for use by later work-packages should they need to retrieve any data yielded. It is thus used by assurers to verify the correctness of data they have been sent by guarantors, and it is later verified as correct by auditors. It is discussed fully in section [14](#sec:workpackagesandworkreports){reference-type="ref" reference="sec:workpackagesandworkreports"}.

The *segment-root* ($e$) is the root of a constant-depth, left-biased and zero-hash-padded binary Merkle tree committing to the hashes of each of the exported segments of each work-item. These are used by guarantors to verify the correctness of any reconstructed segments they are called upon to import for evaluation of some later work-package. It is also discussed in section [14](#sec:workpackagesandworkreports){reference-type="ref" reference="sec:workpackagesandworkreports"}.

### 11.1.4 Work Result

We finally come to define a *work result*, $\mathbb{L}$, which is the data conduit by which services' states may be altered through the computation done within a work-package. $$\begin{aligned}
\label{eq:workresult}
  \mathbb{L} &\equiv (s \in \N_S, c \in \H, l \in \H, g \in \N_G, o \in \Y \cup \mathbb{J})\end{aligned}$$

Work results are a tuple comprising several items. Firstly $s$, the index of the service whose state is to be altered and thus whose refine code was already executed. We include the hash of the code of the service at the time of being reported $c$, which must be accurately predicted within the work-report according to equation [\[eq:reportcodesarecorrect\]](#eq:reportcodesarecorrect){reference-type="ref" reference="eq:reportcodesarecorrect"};

Next, the hash of the payload ($l$) within the work item which was executed in the refine stage to give this result. This has no immediate relevance, but is something provided to the accumulation logic of the service. We follow with the gas prioritization ratio $g$ used when determining how much gas should be allocated to execute of this item's accumulate.

Finally, there is the output or error of the execution of the code $o$, which may be either an octet sequence in case it was successful, or a member of the set $\mathbb{J}$, if not. This latter set is defined as the set of possible errors, formally: $$\begin{aligned}
  \mathbb{J} \in \{ \oog, \panic, \token{BAD}, \token{BIG} \}\end{aligned}$$

The first two are special values concerning execution of the virtual machine, $\oog$ denoting an out-of-gas error and $\panic$ denoting an unexpected program termination. Of the remaining two, the first indicates that the service's code was not available for lookup in state at the posterior state of the lookup-anchor block. The second indicates that the code was available but was beyond the maximum size allowed $\mathsf{S}$.

## 11.2 Package Availability Assurances

We first define $\rho^\ddagger$, the intermediate state to be utilized next in section [11.4](#sec:workreportguarantees){reference-type="ref" reference="sec:workreportguarantees"} as well as $\mathbf{W}$, the set of available work-reports, which will we utilize later in section [12](#sec:accumulation){reference-type="ref" reference="sec:accumulation"}. Both require the integration of information from the assurances extrinsic $\xtassurances$.

### 11.2.1 The Assurances Extrinsic

The assurances extrinsic is a sequence of *assurance* values, at most one per validator. Each assurance is a sequence of binary values (i.e. a bitstring), one per core, together with a signature and the index of the validator who is assuring. A value of $1$ (or $\top$, if interpreted as a Boolean) at any given index implies that the validator assures they are contributing to its availability.[^12] Formally: $$\begin{aligned}
  \xtassurances \in \lseq\ltuple\isa{a}{\H}\ts\isa{f}{\mathbb{B}_\mathsf{C}}\ts\isa{v}{\N_\mathsf{V}}\ts\isa{s}{\mathbb{E}}\rtuple\rseq_\mathsf{:V}\end{aligned}$$

The assurances must all be anchored on the parent and ordered by validator index: $$\begin{aligned}
  \forall a &\in \xtassurances : a_a = \mathbf{H}_p \\
  \forall i &\in \{ 1\dots|\xtassurances| \} : \xtassurances[i - 1]_v < \xtassurances[i]_v\end{aligned}$$

The signature must be one whose public key is that of the validator assuring and whose message is the serialization of the parent hash $\mathbf{H}_p$ and the aforementioned bitstring: $$\begin{aligned}
  &\forall a \in \xtassurances : a_s \in \sig{\kappa'[a_v]_e}{\mathsf{X}_A\frown \mathcal{H}(\mathbf{H}_p, a_f)} \\
  &\mathsf{X}_A \equiv \token{\$jam\_available}\end{aligned}$$

A bit may only be set if the corresponding core has a report pending availability on it: $$\begin{aligned}
  \forall a \in \xtassurances : \forall c \in \N_\mathsf{C} : a_f[c] \implies \rho^\dagger[c] \ne \none\end{aligned}$$

### 11.2.2 Available Reports

A work-report is said to become *available* if and only if there are a clear super-majority of validators who have marked its core as set within the block's assurance extrinsic. Formally, we define the series of available work-reports $\mathbf{W}$ as: $$\begin{aligned}
\label{eq:availableworkreports}
  \mathbf{W} &\equiv \left[\rho^\dagger[c]_w\,\middle\vert\,c \orderedin \N_\mathsf{C},\;\sum_{a \in \xtassurances}\!a_f[c]\,>\,\nicefrac{2}{3}\,\mathsf{V}\right]\end{aligned}$$

This value is utilized in the definition of both $\delta'$ and $\rho^\ddagger$ which we will define presently as equivalent to $\rho^\dagger$ except for the removal of items which are now available: $$\begin{aligned}
  \forall c \in \N_\mathsf{C}: \rho^\ddagger[c] \equiv \begin{cases}
    \none &\when\rho[c]_w \in \mathbf{W}\\
    \rho^\dagger[c] &\otherwise
  \end{cases}\end{aligned}$$

## 11.3 Guarantor Assignments {#sec:coresandvalidators}

Every block, each core has three validators uniquely assigned to guarantee work-reports for it. This is borne out with $\mathsf{V} = 1,023$ validators and $\mathsf{C} = 341$ cores, since $\nicefrac{\mathsf{V}}{\mathsf{C}} = 3$. The core index assigned to each of the validators, as well as the validators' Ed25519 keys are denoted by $\mathbf{G}$: $$\mathbf{G} \in (\seq{\N_\mathsf{C}}_{\N_V}, \seq{\mathbb{H}_K}_{\N_V})$$

We determine the core to which any given validator is assigned through a shuffle using epochal entropy and a periodic rotation to help guard the security and liveness of the network. We use $\eta_2$ for the epochal entropy rather than $\eta_1$ to avoid the possibility of fork-magnification where uncertainty about chain state at the end of an epoch could give rise to two established forks before it naturally resolves.

We define the permute function $P$, the rotation function $R$ and finally the guarantor assignments $\mathbf{G}$ as follows: $$\begin{aligned}
  R(\mathbf{c}, n) &\equiv [(x + n) \bmod \mathsf{C} \mid x \orderedin \mathbf{c}]\\
  P(e, t) &\equiv R\left(\mathcal{F}\left(\left[\ffrac{\mathsf{C}\cdot i}{\mathsf{V}} \,\middle\mid\, i \orderedin \N_\mathsf{V}\right], e\right), \ffrac{t \bmod \mathsf{E}}{\mathsf{R}}\right)\\
  \mathbf{G} &\equiv (P(\eta_2', \tau'), \Phi(\kappa'))\end{aligned}$$

We also define $\mathbf{G}^*$, which is equivalent to the value $\mathbf{G}$ as it would have been under the previous rotation: $$\label{eq:priorassignments}
  \begin{aligned}
    \using (e, \mathbf{k}) &= \begin{cases}
      (\eta'_2, \kappa') &\when \displaystyle\ffrac{\tau' - \mathsf{R}}{\mathsf{E}} = \ffrac{\tau'}{\mathsf{E}}\\
      (\eta'_3, \lambda') &\otherwise
    \end{cases} \\
    \mathbf{G}^* &\equiv (P(e, \tau' - \mathsf{R}), \Phi(\mathbf{k}))
  \end{aligned}$$

## 11.4 Work Report Guarantees {#sec:workreportguarantees}

We begin by defining the guarantees extrinsic, $\xtguarantees$, a series of *guarantees*, at most one for each core, each of which is a tuple of a *work-report*, a credential $a$ and its corresponding timeslot $t$. The core index of each guarantee must be unique and guarantees must be in ascending order of this. Formally: $$\begin{aligned}
\label{eq:guaranteesextrinsic}
  \xtguarantees &\in \seq{\tuple{
    w \in \mathbb{W},\, t \in \N_T,\, a \in \seq{\tuple{\N_V, \mathbb{E}}}_{2:3}
  }}_{:\mathsf{C}} \\
  \xtguarantees &= \orderby{(g_w)_c}{g \in \xtguarantees}\end{aligned}$$

The credential is a sequence of two or three tuples of a unique validator index and a signature. Credentials must be ordered by their validator index: $$\begin{aligned}
  \forall g &\in \xtguarantees : g_a = \orderuniqby{v}{\tup{v, s} \in g_a}\end{aligned}$$

The signature must be one whose public key is that of the validator identified in the credential, and whose message is the serialization of the hash of the work-report. The signing validators must be assigned to the core in question in either this block $\mathbf{G}$ if the timeslot for the guarantee is in the same rotation as this block's timeslot, or in the most recent previous set of assignments, $\mathbf{G}^*$: $$\begin{aligned}
\label{eq:guarantorsig}
  &\begin{aligned}
    &\begin{aligned}
      \forall (w, t, a) &\in \xtguarantees,\\
      \forall (v, s) &\in a
    \end{aligned}
      : \left\{\,\begin{aligned}
        &s \in \sig{(\mathbf{k}_v)_E}{\mathsf{X}_G\frown\mathcal{H}(\se(w))}\\
        &\mathbf{c}_v = w_c \wedge \mathsf{R}(\floor{\nicefrac{\tau'}{\mathsf{R}}} - 1) \le t \le \tau'\\
      \end{aligned}\right.\\
      &k \in \mathbf{R} \Leftrightarrow \exists (w, t, a) \in \xtguarantees, \exists (v, s) \in a: k = (\mathbf{k}_v)_E\\
      &\quad\where (\mathbf{c}, \mathbf{k}) = \begin{cases}
        \mathbf{G} &\when \displaystyle \ffrac{\tau'}{\mathsf{R}} = \ffrac{t}{\mathsf{R}} \\
        \mathbf{G}^* &\otherwise
      \end{cases}
  \end{aligned}\\
  &\mathsf{X}_G \equiv \token{\$jam\_guarantee}\end{aligned}$$

We note that the Ed25519 key of each validator whose signature is in a credential is placed in the *reporters* set $\mathbf{R}$. This is utilized by the validator activity statistics bookkeeping system section [13](#sec:bookkeeping){reference-type="ref" reference="sec:bookkeeping"}.

We denote $\mathbf{w}$ to be the set of work-reports in the present extrinsic $\mathbf{E}$: $$\begin{aligned}
  \text{let}\ \mathbf{w} = \{ g_w \mid g \in \xtguarantees \}\end{aligned}$$

No reports may be placed on cores with a report pending availability on it unless it has timed out. In the latter case, $\mathsf{U} = 5$ slots must have elapsed after the report was made. A report is valid only if the authorizer hash is present in the authorizer pool of the core on which the work is reported. Formally: $$\label{eq:reportcoresareunusedortimedout}
  \forall w \in \mathbf{w} :\left\{\;\begin{aligned}
    &\rho^\ddagger[w_c] = \none \vee \mathbf{H}_t \ge \rho^\ddagger[w_c]_t + \mathsf{U}\ , \\
    &w_a \in \alpha[w_c]
  \end{aligned}\right.$$

We specify the maximum total accumulation gas requirement a work-report may imply as $\mathsf{G}_A$, and we require the sum of all services' minimum gas requirements to be no greater than this: $$\begin{aligned}
  \forall w \in \mathbf{w}: \sum_{s \in (w_r)_s}{\delta[s]_g}\ \le\ \mathsf{G}_A\end{aligned}$$

### 11.4.1 Contextual Validity of Reports {#sec:contextualvalidity}

For convenience, we define two equivalences $\mathbf{x}$ and $\mathbf{p}$ to be, respectively, the set of all contexts and work-package hashes within the extrinsic: $$\using \mathbf{x} \equiv \{ w_x \mid w \in \mathbf{w} \}\ ,\quad
    \mathbf{p} \equiv \{ (w_s)_h \mid w \in \mathbf{w} \}$$

There must be no duplicate work-package hashes (i.e. two work-reports of the same package). Therefore, we require the cardinality of $\mathbf{p}$ to be the length of the work-report sequence $\mathbf{w}$: $$|\mathbf{p}| = |\mathbf{w}|$$

We require that the anchor block be within the last $\mathsf{H}$ blocks and that its details be correct by ensuring that it appears within our most recent blocks $\beta$: $$\begin{aligned}
  \forall x \in \mathbf{x} : \exists y \in \beta : x_a = y_h \wedge x_s = y_s \wedge x_b = \mathcal{H}_K(\se_M(y_\mathbf{b}))\!\!\!\!\!\!\end{aligned}$$

We require that each lookup-anchor block be within the last $\mathsf{L}$ timeslots: $$\begin{aligned}
  \forall x \in \mathbf{x} :\ x_t \ge \mathbf{H}_t - \mathsf{L}\end{aligned}$$

We also require that we have a record of it; this is one of the few conditions which cannot be checked purely with on-chain state and must be checked by virtue of retaining the series of the last $\mathsf{L}$ headers as the ancestor set $\mathbf{A}$. Since it is determined through the header chain, it is still deterministic and calculable. Formally: $$\begin{aligned}
  \forall x \in \mathbf{x} :\ \exists h \in \mathbf{A}: h_t = x_t \wedge \mathcal{H}(h) = x_h\end{aligned}$$

We require that the work-package of the report not be the work-package of some other report made in the past. Since the work-package implies the anchor block, and the anchor block is limited to the most recent blocks, we need only ensure that the work-package not appear in our recent history: $$\forall p \in \mathbf{p}, \forall x \in \beta : p \not\in x_\mathbf{p}$$

We require that the prerequisite work-package, if present, be either in the extrinsic or in our recent history: $$\begin{aligned}
  &\forall w \in \mathbf{w}, (w_x)_p \ne \none :\\
  &\quad(w_x)_p \in \mathbf{p} \cup \{ x \mid x \in b_\mathbf{p} ,\, b \in \beta \}
\end{aligned}$$

We require that all work results within the extrinsic predicted the correct code hash for their corresponding service: $$\begin{aligned}
\label{eq:reportcodesarecorrect}
  \forall w \in \mathbf{w}, \forall r \in w_r : r_c = \delta[r_s]_c\end{aligned}$$

## 11.5 Transitioning for Reports

We define $\rho'$ as being equivalent to $\rho^\ddagger$, except where the extrinsic replaced an entry. In the case an entry is replaced, the new value includes the present time $\tau'$ allowing for the value to be replaced without respect to its availability once sufficient time has elapsed (see equation [\[eq:reportcoresareunusedortimedout\]](#eq:reportcoresareunusedortimedout){reference-type="ref" reference="eq:reportcoresareunusedortimedout"}). $$\forall c \in \N_\mathsf{C} : \rho'[c] \equiv \begin{cases}
      \tup{w\ts\is{t}{\tau'}} &\when \exists \tup{c, w, a} \in \xtguarantees \\
      \rho^\ddagger[c] &\otherwise
    \end{cases}$$

This concludes the section on reporting and assurance. We now have a complete definition of $\rho'$ together with $\mathbf{W}$ to be utilized in section [12](#sec:accumulation){reference-type="ref" reference="sec:accumulation"}, describing the portion of the state transition happening once a work-report is guaranteed and made available.

# 12 Accumulation {#sec:accumulation}

Accumulation may be defined as some function whose arguments are $\mathbf{W}$ and $\delta$ together with selected portions of (at times partially transitioned) state and which yields the posterior service state $\delta'$ together with additional state elements $\iota'$, $\varphi'$ and $\chi'$.

The proposition of accumulation is in fact quite simple: we merely wish to execute the *Accumulate* logic of the service code of each of the services which has at least one work output, passing to it the work outputs and useful contextual information. However, there are three main complications. Firstly, we must define the execution environment of this logic and in particular the host functions available to it. Secondly, we must define the amount of gas to be allowed for each service's execution. Finally, we must determine the nature of transfers within Accumulate which, as we will see, leads to the need for a second entry-point, *on-transfer*.

## 12.1 Preimage Integration

Prior to accumulation, we must first integrate all preimages provided in the lookup extrinsic. The lookup extrinsic is a sequence of pairs of service indices and data. These pairs must be ordered and without duplicates (equation [\[eq:preimagesareordered\]](#eq:preimagesareordered){reference-type="ref" reference="eq:preimagesareordered"} requires this). The data must have been solicited by a service but not yet be provided. Formally: $$\begin{aligned}
  \xtpreimages &\in \lseq \ltuple\N_S\ts\Y\rtuple \rseq \\
  \label{eq:preimagesareordered}\xtpreimages &= \orderuniqby{i}{i \in \xtpreimages} \\
  \forall \tup{s\ts\mathbf{p}} \in \xtpreimages &: \left\{\ 
    \begin{aligned}
      &\keys{\delta[s]_\mathbf{p}}\ \not\ni\ \mathcal{H}(\mathbf{p})\ ,\\
      &\delta[s]_\mathbf{l}[\tup{\mathcal{H}(\mathbf{p}), |\mathbf{p}|}]\ =\ []
    \end{aligned}
  \right.\end{aligned}$$

We define $\delta^\dagger$ as the state after the integration of the preimages: $$\begin{aligned}
    \delta^\dagger = \delta \text{ ex. } \forall \tup{s\ts\mathbf{p}} \in \xtpreimages : \left\{\,\begin{aligned}
      \quad\delta^\dagger[s]_\mathbf{p}[\mathcal{H}(\mathbf{p})] &= \mathbf{p} \\
      \delta^\dagger[s]_\mathbf{l}[\mathcal{H}(\mathbf{p}), |\mathbf{p}|] &= [\tau']
    \end{aligned}\right.\!\!\end{aligned}$$

## 12.2 Gas Accounting

We define $\mathbf{S}$, the set of all services which will be accumulated in this block; this is all services which have at least one work output within $\mathbf{W}$, together with the privileged services, $\chi_\mathbf{g}$. Formally: $$\begin{aligned}
\label{eq:servicestoaccumulate}
  \mathbf{S} \equiv \{ \mathbf{r}_s \mid w \in \mathbf{W}, \mathbf{r} \in w_\mathbf{r} \} \cup \keys(\chi_\mathbf{g})\end{aligned}$$

We calculate the gas attributable for each service as the sum of each of the service's work outputs' share of their report's elective accumulation gas together with the subtotal of minimum gas requirements: $$G\colon\left\{\;\begin{aligned}
    \N_S &\to \N_G \\
    \displaystyle s &\mapsto \!\!\sum_{w \in \mathbf{W}}\sum_{\mathbf{r} \in w_\mathbf{r} , \mathbf{r}_s = s}{\!\!\!\!\!\!\!\delta^\dagger[s]_g + \left \lfloor \mathbf{r}_g\cdot\frac{\displaystyle \mathsf{G}_A - \sum_{\mathbf{r} \in w_\mathbf{r}}{\delta^\dagger[\mathbf{r}_s]_g}}{\sum_{\mathbf{r} \in w_\mathbf{r}}{\mathbf{r}_g}} \right \rfloor }
  \end{aligned}\right.\!\!\!\!\!\!$$

## 12.3 Wrangling

We finally define the results which will be given as an operand into the accumulate function for each service in $\mathbf{S}$. This is a sequence of operand tuples $\mathbb{O}$, one sequence for each service in $\mathbf{S}$. Each sequence contains one element per work output (or error) to be accumulated for that service, together with said work output's payload hash, package hash and authorization output. The tuples are sequenced in the same order as they appear in $\mathbf{W}$. Formally: $$\begin{aligned}
  \mathbb{O} \equiv \ltuple\isa{o}{\Y \cup \mathbb{J}}\ts\isa{l}{\H}\ts\isa{k}{\H}\ts\isa{a}{\Y}\rtuple\end{aligned}$$ $$\begin{aligned}
  M\colon\left\{\ \begin{aligned}
    \N_S &\to \lseq\mathbb{O}\rseq \\
    \displaystyle s &\mapsto \left[ \ltup\begin{alignedat}{3}
        \is{o&}{\mathbf{r}_o}\ts\is{&l&}{\mathbf{r}_p}\ts\\
        \is{a&}{w_o}\ts\is{&k&}{(w_s)_h}
    \end{alignedat}\rtup
      \,\middle\vert\ 
    \begin{aligned}
      w &\in \mathbf{W},\\
      \mathbf{r} &\in w_\mathbf{r},\\
      \mathbf{r}_s &= s
    \end{aligned}\ \right]
  \end{aligned}\right.\end{aligned}$$

## 12.4 Invocation

Within this section, we define $A$, the function which conducts the accumulation of a single service. Formally speaking, $A$ assumes omnipresence of timeslot $\mathbf{H}_t$ and some prior state components $\delta^\dagger$, $\nu$, $\mathbf{W}_\mathbf{d}$, and takes as specific arguments the service index $s \in \mathbf{S}$ (from which it may derive the wrangled results $M(s)$ and gas limit $G(s)$) and yields values for $\delta^\ddagger[s]$ and staging assignments into $\varphi$, $\iota$ together with a series of lookup solicitations/forgets, a series of deferred transfers and $\mathbf{C}$ mapping from service index to [Beefy]{.smallcaps} commitment hashes.

We first denote the set of deferred transfers as $\mathbb{T}$, noting that a transfer includes a memo component $m$ of $\mathcal{M} = 128$ octets, together with the service index of the sender $s$, the service index of the receiver $d$, the amount of tokens to be transferred $a$ and the gas limit $g$ for the transfer. Formally: $$\begin{aligned}
  \mathbb{T} \equiv \ltuple\isa{s}{\N_S}\ts\isa{d}{\N_S}\ts\isa{a}{\N_B}\ts\isa{m}{\Y_{\mathsf{M}}}\ts\isa{g}{\N_G}\rtuple\end{aligned}$$

We may then define $A$, the mapping from the index of accumulated services to the various components in terms of which we will be imminently defining our posterior state: $$\begin{aligned}
  A \colon \left\{\begin{aligned}
      \N_S &\to \ltuple\ \begin{aligned}
        \isa{\mathbf{s}&}{\mathbb{A}\bm{?}}\ts\quad
        \isa{\mathbf{v}}{\seq{\mathbb{K}}_\mathsf{V}}\ts\quad
        \isa{\mathbf{t}}{\seq{\mathbb{T}}}\ts\quad
        \isa{r}{\H\bm{?}}\ts\\
        \isa{\mathbf{c}&}{\lseq\lseq\H\rseq_\mathsf{Q}\rseq_\mathsf{C}}\ts\qquad
        \isa{\mathbf{n}}{\dict{\N_S}{\mathbb{A}}}\ts\\
        \isa{p&}{\tuple{\isa{m}{\N_S}, \isa{a}{\N_S}, \isa{v}{\N_S}, \isa{\mathbf{g}}{\dict{\N_S}{\N_G}}}}\\
      \end{aligned}\rtuple \\
      s &\mapsto \Psi_A(\delta^\dagger, s, G(s) + \subifnone((\chi_\mathbf{g})_s, 0), M(s))
    \end{aligned}\right.\end{aligned}$$

As can be seen plainly, our accumulation mapping $A$ combines portions of the prior state into arguments for a virtual-machine invocation. Specifically the service accounts $\delta^\dagger$ together with the index of the service in question $s$ and its gas limit and wrangled refine-results $M(s)$ are arranged to create the arguments for $\Psi_A$, itself using a virtual-machine invocation as defined in appendix [25.4](#sec:accumulateinvocation){reference-type="ref" reference="sec:accumulateinvocation"}. Note that the gas limit is the sum of the regular gas $G(s)$ together with any privileged gas it receives $(\chi_\mathbf{g})_s$.

The [Beefy]{.smallcaps} commitment map is a function mapping all accumulated services to their accumulation result (the $r$ component of the result of $A$). This is utilized in determining the accumulation-result tree root for the present block, useful for the [Beefy]{.smallcaps} protocol: $$\label{eq:beefycommitment}
  \mathbf{C} \equiv \{ (s, A(s)_r) \mid s \in \mathbf{S}, A(s)_r \ne \none \}$$

Given our mapping $A$, which may be calculated exhaustively from the [vm]{.smallcaps} invocations of each accumulated service $\mathbf{S}$, we may define the posterior state $\delta'$, $\chi'$, $\varphi'$ and $\iota'$ as the result of integrating $A$ into our state.

### 12.4.1 Privileged Transitions

The staging core assignments, and validator keys and privileged service set are each altered based on the effects of the accumulation of each of the three privileged services: $$\begin{aligned}
  \chi' \equiv A(\chi_m)_p \ ,\quad
  \varphi' \equiv A(\chi_a)_\mathbf{c} \ ,\quad
  \iota' \equiv A(\chi_v)_\mathbf{v}\end{aligned}$$

### 12.4.2 Service Account Transitions

Finally, we integrate all changes to the service accounts into state.

We note that all newly added service indices, defined as $\keys{A(s)_\mathbf{n}}$ for any accumulated service $s$, must not conflict with the indices of existing services or newly added services. This should never happen, since new indices are explicitly selected to avoid such conflicts, but in the unlikely event it happens, the block would be invalid. Formally: $$\begin{aligned}
  \forall s \in \mathbf{S} :\ &\keys{A(s)_\mathbf{n}} \cap \keys{\delta^\dagger} = \none, \\
  \forall t \in \mathbf{S} \setminus \{s\} :\ &\keys{A(s)_\mathbf{n}} \cap \keys{A(t)_\mathbf{n}} = \none
\end{aligned}$$

We first define $\delta^\ddagger$, an intermediate state after main accumulation but before the transfers have been credited and handled: $$\begin{aligned}
  \keys{\delta^\ddagger} &\equiv \left ( \keys{\delta^\dagger} \cup \bigcup_{s \in \mathbf{S}} \keys{A(s)_\mathbf{n}} \right ) \setminus \left\{s\ \middle\vert\ \begin{aligned}s &\in \mathbf{S},\\s_\mathbf{s} &= \none\end{aligned}\ \right\}\!\!\\
  \delta^\ddagger[s] &\equiv \begin{cases}
    A(s)_\mathbf{s} &\when s \in \mathbf{S}\\
    A(t)_\mathbf{n}[s] &\when \exists! t : t \in \mathbf{S}, s \in \keys{A(t)_\mathbf{n}} \\
    \delta^\dagger[s] &\otherwise
  \end{cases}
\end{aligned}$$

We denote $R(s)$ the sequence of transfers received by a given service of index $s$, in order of them being sent from services of ascending index. (If some service $s$ received no transfers or simply does not exist then $R(s)$ would be validly defined as the empty sequence.) Formally: $$\begin{aligned}
  R\colon \left\{\;\begin{aligned}
    \N_S &\to \lseq\mathbb{T}\rseq \\
    d &\mapsto \left[\,t \mid s \orderedin \mathbf{S},\ t \orderedin A(s)_\mathbf{t},\ t_d = d\,\right]
  \end{aligned}\right.\end{aligned}$$

The posterior state $\delta'$ may then be defined as the intermediate state with all the deferred effects of the transfers applied: $$\delta' = \{ s \mapsto \Psi_T(\delta^\ddagger, a, R(a)) \mid (s \mapsto a) \in \delta^\ddagger \}$$

Note that $\Psi_T$ is defined in appendix [25.5](#sec:ontransferinvocation){reference-type="ref" reference="sec:ontransferinvocation"} such that it results in $\delta^\ddagger[d]$, i.e. no difference to the account's intermediate state, if $R(d) = []$, i.e. said account received no transfers.

# 13 Validator Activity Statistics {#sec:bookkeeping}

The JAM chain does not explicitly issue rewards---we leave this as a job to be done by the staking subsystem (in Polkadot's case envisioned as a system parachain---hosted without fees---in the current imagining of a public JAM network). However, much as with validator punishment information, it is important for the JAM chain to facilitate the arrival of information on validator activity in to the staking subsystem so that it may be acted upon.

Such performance information cannot directly cover all aspects of validator activity; whereas block production, guarantor reports and availability assurance can easily be tracked on-chain, [Grandpa]{.smallcaps}, [Beefy]{.smallcaps} and auditing activity cannot. In the latter case, this is instead tracked with validator voting activity: validators vote on their impression of each other's efforts and a median may be accepted as the truth for any given validator. With an assumption of 50% honest validators, this gives an adequate means of oraclizing this information.

The validator statistics are made on a per-epoch basis and we retain one record of completed statistics together with one record which serves as an accumulator for the present epoch. Both are tracked in $\pi$, which is thus a sequence of two elements, with the first being the accumulator and the second the previous epoch's statistics. For each epoch we track a performance record for each validator: $$\pi \in \seq{\seq{\tuple{
    \isa{b}{\N}\,,
    \isa{t}{\N}\,,
    \isa{p}{\N}\,,
    \isa{d}{\N}\,,
    \isa{g}{\N}\,,
    \isa{a}{\N}
%    \isa{\mathbf{u}}{\seq{\N}_\mathsf{V}}
  }}_\mathsf{V}}_2$$

The six statistics we track are:

$b$

:   The number of blocks produced by the validator.

$t$

:   The number of tickets introduced by the validator.

$p$

:   The number of preimages introduced by the validator.

$d$

:   The total number of octets across all preimages introduced by the validator.

$g$

:   The number of reports guaranteed by the validator.

$a$

:   The number of availability assurances made by the validator.

The objective statistics are updated in line with their description, formally: $$\begin{aligned}
    \using e =\; &\ffrac{\tau}{\mathsf{E}} \ ,\quad e' = \ffrac{\tau'}{\mathsf{E}}\\
    (\mathbf{a}, \pi'_1) \equiv\;&\begin{cases}
        (\pi_0, \pi_1) &\when e' = e \\
        (\sq{\tuple{0, \dots, [0, \dots]}, \dots}, \pi_0) &\otherwise
    \end{cases}\\
    \forall v \in \N_\mathsf{V} :&\; \left\{\begin{aligned}
        \pi'_0[v]_b &\equiv \mathbf{a}[v]_b + (v = \mathbf{H}_i)\\
        \pi'_0[v]_t &\equiv \mathbf{a}[v]_t + \begin{cases}
            |\xttickets| &\when v = \mathbf{H}_i \\
            0 &\otherwise
        \end{cases}\\
        \pi'_0[v]_p &\equiv \mathbf{a}[v]_p + \begin{cases}
            |\xtpreimages| &\when v = \mathbf{H}_i \\
            0 &\otherwise
        \end{cases}\\
        \pi'_0[v]_d &\equiv \mathbf{a}[v]_d + \begin{cases}
            \sum_{d \in \xtpreimages}|d| &\when v = \mathbf{H}_i \\
            0 &\otherwise
        \end{cases}\\
        \pi'_0[v]_g &\equiv \mathbf{a}[v]_g + (\kappa'_v \in \mathbf{R})\\
        \pi'_0[v]_a &\equiv \mathbf{a}[v]_a + (\exists a \in \xtassurances : a_v = v)
    \end{aligned}\right.\end{aligned}$$

Note that $\mathbf{R}$ is the *Reporters* set, as defined in equation [\[eq:guarantorsig\]](#eq:guarantorsig){reference-type="ref" reference="eq:guarantorsig"}.

# 14 Work Packages and Work Reports {#sec:workpackagesandworkreports}

## 14.1 Honest Behavior

We have so far specified how to recognize blocks for a correctly transitioning JAM blockchain. Through defining the state transition function and a state Merklization function, we have also defined how to recognize a valid header. While it is not especially difficult to understand how a new block may be authored for any node which controls a key which would allow the creation of the two signatures in the header, nor indeed to fill in the other header fields, readers will note that the contents of the extrinsic remain unclear.

We define not only correct behavior through the creation of correct blocks but also *honest behavior*, which involves the node taking part in several *off-chain* activities. This does have analogous aspects within *YP* Ethereum, though it is not mentioned so explicitly in said document: the creation of blocks along with the gossiping and inclusion of transactions within those blocks would all count as off-chain activities for which honest behavior is helpful. In JAM's case, honest behavior is well-defined and expected of at least $\nicefrac{2}{3}$ of validators.

Beyond the production of blocks, incentivized honest behavior includes:

-   the guaranteeing and reporting of work-packages, along with chunking and distribution of both the chunks and the work-package itself, discussed in section [15](#sec:guaranteeing){reference-type="ref" reference="sec:guaranteeing"};

-   assuring the availability of work-packages after being in receipt of their data;

-   determining which work-reports to audit, fetching and auditing them, and creating and distributing judgements appropriately based on the outcome of the audit;

-   submitting the correct amount of auditing work seen being done by other validators, discussed in section [13](#sec:bookkeeping){reference-type="ref" reference="sec:bookkeeping"}.

## 14.2 Segments and the Manifest

Our basic erasure-coding segment size is $\mathsf{W}_C = 684$ octets, derived from the fact we wish to be able to reconstruct even should almost two-thirds of our 1023 participants be malicious or incapacitated, the 16-bit Galois field on which the erasure-code is based and the desire to efficiently support encoding data of close to, but no less than, 4[kb]{.smallcaps}.

Work-packages are generally small to ensure guarantors need not invest a lot of bandwidth in order to discover whether they can get paid for their evaluation into a work-report. Rather than having much data inline, they instead *reference* data through commitments. The simplest commitments are extrinsic data.

Extrinsic data are blobs which are being introduced into the system alongside the work-package itself generally by the work-package builder. They are exposed to the Refine logic as an argument. We commit to them through including each of their hashes in the work-package.

Work-packages have two other types of external data associated with them: A cryptographic commitment to each *imported* segment and finally the number of segments which are *exported*.

### 14.2.1 Segments, Imports and Exports

The ability to communicate large amounts of data from one work-package to some subsequent work-package is a key feature of the JAM availability system. An export segment, defined as the set $\G$, is an octet sequence of fixed length $\mathsf{W}_S\mathsf{W}_C = 4104$. It is the smallest datum which may individually be imported from---or exported to---the long-term *Imports DA* during the Refine function of a work-package. Being an exact multiple of the erasure-coding piece size ensures that the data segments of work-package can be efficiently placed in the DA system. $$\label{eq:segment}
  \G \equiv \Y_{\mathsf{W}_S\mathsf{W}_C}$$

Exported segments are data which are *generated* through the execution of the Refine logic and thus are a side effect of transforming the work-package into a work-report. Since their data is deterministic based on the execution of the Refine logic, we do not require any particular commitment to them in the work-package beyond knowing how many are associated with each Refine invocation in order that we can supply an exact index.

On the other hand, imported segments are segments which were exported by previous work-packages. In order for them to be easily fetched and verified they are referenced not by hash but rather the root of a Merkle tree which includes any other segments introduced at the time, together with an index into this sequence. This allows for justifications of correctness to be generated, stored, included alongside the fetched data and verified. This is described in depth in the next section.

### 14.2.2 Data Collection and Justification

It is the task of a guarantor to reconstitute all imported segments through fetching said segments' erasure-coded chunks from enough unique validators. Reconstitution alone is not enough since corruption of the data would occur if one or more validators provided an incorrect chunk. For this reason we ensure that the import segment specification (a Merkle root and an index into the tree) be a kind of cryptographic commitment capable of having a justification applied to demonstrate that any particular segment is indeed correct.

Justification data must be available to any node over the course of its segment's potential requirement. At around 350 bytes to justify a single segment, justification data is too voluminous to have all validators store all data. We therefore use the same overall availability framework for hosting justification metadata as the data itself.

The guarantor is able to use this proof to justify to themselves that they are not wasting their time on incorrect behavior. We do not force auditors to go through the same process. Instead, guarantors build an *Auditable Work Package*, and place this in the Audit DA system. This is the original work-package, its extrinsic data, its imported data and a concise proof of correctness of that imported data. This tactic routinely duplicates data between the Imports DA and the Audits DA, however it is acceptable in order to reduce the bandwidth cost for auditors who must justify the correctness as cheaply as possible as auditing happens on average 30 times for each work-package whereas guaranteeing happens only twice or thrice.

## 14.3 Packages and Items {#sec:packagesanditems}

We begin by defining a *work-package*, of set $\mathbb{P}$, and its constituent *work item*s, of set $\mathbb{I}$. A work-package includes a simple blob acting as an authorization token $\wpNauthtoken$, the index of the service which hosts the authorization code $\wpNauthcodehost$, an authorization code hash $\wpNauthcodehash$ and a parameterization blob $\wpNauthparam$, a context $\wpNcontext$ and a sequence of work items $\wpNworkitems$: $$\label{eq:workpackage}
  \mathbb{P} \equiv \tuple{\;\begin{aligned}
    &\isa{\wpNauthtoken}{\Y},\ \isa{\wpNauthcodehost}{\N_S},\ \isa{\wpNauthcodehash}{\H},\\
    &\isa{\wpNauthparam}{\Y},\ \isa{\wpNcontext}{\mathbb{X}},\ \isa{\wpNworkitems}{\seq{\mathbb{I}}_{1:\mathsf{I}}}
  \end{aligned}}$$

A work item includes: $s$ the identifier of the service to which it relates, the code hash of the service at the time of reporting $c$ (whose preimage must be available from the perspective of the lookup anchor block), a payload blob $\mathbf{y}$, a gas limit $g$, and the three elements of its manifest, a sequence of imported data segments $\wiNimportsegments$ identified by the root of the *segments tree* and an index into it, $\wiNextrinsics$, a sequence of hashed of blob hashes and lengths to be introduced in this block (and which we assume the validator knows) and $\wiNexportsegments$ the number of data segments exported by this work item: $$\label{eq:workitem}
    \mathbb{I} \equiv \tuple{\begin{aligned}
      &\isa{s}{\N_S} \ts
      \isa{c}{\H} \ts
      \isa{\mathbf{y}}{\Y} \ts
      \isa{g}{\N_G} \ts \\
      &\isa{\wiNimportsegments}{\seq{\tuple{\H,\N}}} \ts
      \isa{\wiNextrinsics}{\seq{(\H, \N)}} \ts
      \isa{\wiNexportsegments}{\N}
    \end{aligned}}$$

We limit the total number of exported items to $\mathsf{W}_M = 2^{11}$. We also place the same limit on the total number of imported items: $$\begin{aligned}
  \forall p\in \mathbb{P}:
  \sum_{w\in p_\wpNworkitems} w_\wiNexportsegments &\le \mathsf{W}_M \ \wedge\ 
  \sum_{w\in p_\wpNworkitems} |w_\wiNimportsegments| \le \mathsf{W}_M\end{aligned}$$

We make an assumption that the preimage to each extrinsic hash in each work-item is known by the guarantor. In general this data will be passed to the guarantor alongside the work-package.

We limit the encoded size of a work-package plus the total size of the implied import and extrinsic items to 12[mb]{.smallcaps} in order to allow for around 2[mb]{.smallcaps}/s/core data throughput: $$\begin{aligned}
  \label{eq:checkextractsize}
  \forall p&\in \mathbb{P}: \left(
  \sum_{w\in p_\wpNworkitems} |w_\wiNimportsegments|\cdot\mathsf{W}_S\mathsf{W}_C + \sum_{w\in p_\wpNworkitems} \sum_{(h, l) \in w_\wiNextrinsics} \!\!\!l\right) \le \mathsf{W}_P \\
  \mathsf{W}_P &= 12\cdot2^{20}\end{aligned}$$

Given the result $o$ of some work-item, we define the item-to-result function $C$ as: $$C\colon\left\{\begin{aligned}
    (\mathbb{I}, \Y \cup \mathbb{J}) &\to \mathbb{L}\\
    ((s, c, \mathbf{y}, g), o) &\mapsto (s, c, \mathcal{H}(\mathbf{y}), g, o)
  \end{aligned}\right.$$

We define the work-package's implied authorizer as $p_\wpNauthorizer$, the hash of the concatenation of the authorization code and the parameterization. We define the authorization code as $p_\wpNauthcode$ and require that it be available at the time of the lookup anchor block from the historical lookup of service $p_\wpNauthcodehost$. Formally: $$\forall p\in \mathbb{P}: \left\{\,\begin{aligned}
    p_\wpNauthorizer &\equiv \mathcal{H}(p_\wpNauthcode \concat p_\wpNauthparam) \\
    p_\wpNauthcode &\equiv \Lambda(\delta[p_\wpNauthcodehost], (p_\wpNcontext)_t, p_\wpNauthcodehash) \\
    p_\wpNauthcode &\in \Y
  \end{aligned}\right.$$

(The historical lookup function, $\Lambda$, is defined in equation [\[eq:historicallookup\]](#eq:historicallookup){reference-type="ref" reference="eq:historicallookup"}.)

### 14.3.1 Exporting

Any of a work-package's work-items may *export* segments and a *segments-root* is placed in the work-report committing to these, ordered according to the work-item which is exporting. It is formed as the root of a constant-depth binary Merkle tree as defined in equation [\[eq:constantdepthmerkleroot\]](#eq:constantdepthmerkleroot){reference-type="ref" reference="eq:constantdepthmerkleroot"}.

Guarantors are required to erasure-code and distribute two data sets: one blob, the auditable work-package containing the encoded work-package, extrinsic data and self-justifying imported segments which is placed in the short-term Audit DA store and a second set of exported-segments data together with the *Paged-Proofs* metadata. Items in the first store are short-lived; assurers are expected to keep them only until finality of the block which included the work-result. Items in the second, meanwhile, are long-lived and expected to be kept for a minimum of 28 days (672 complete epochs) following the reporting of the work-report.

We define the paged-proofs function $P$ which accepts a series of exported segments $\mathbf{s}$ and defines some series of additional segments placed into the Imports DA system via erasure-coding and distribution. The function evaluates to pages of hashes, together with subtree proofs, such that justifications of correctness based on a segments-root may be made from it: $$\label{eq:pagedproofs}
  P\colon\left\{\begin{aligned}
    \seq{\G} \to \,&\seq{\G} \\
    \mathbf{s} \mapsto \,&[
      \mathcal{P}_l(\se(
        \var{\mathcal{J}_6(\mathbf{s}, i)},
        \var{\mathbf{s}_{i\dots+64}}
      ))
      \mid i \orderedin 64\cdot\N_{\ceil{\nicefrac{|\mathbf{s}|}{64}}}
    ] \\
    & \where l = \mathsf{W}_S\mathsf{W}_C
  \end{aligned}\right.$$

Note: in the case that $|\mathbf{s}|$ is not a multiple of 64, then the term $\mathbf{s}_{i\dots+64}$ will correctly refer to fewer than 64 elements if it is the final page.

## 14.4 Computation of Work Results {#sec:computeworkresult}

We now come to the work result computation function $\Xi$. This forms the basis for all utilization of cores on JAM. It accepts some work-package $p$ for some nominated core $c$ and results in either an error $\error$ or the work result and series of exported segments. This function is deterministic and requires only that it be evaluated within eight epochs of a recently finalized block thanks to the historical lookup functionality. It can thus comfortably be evaluated by any node within the auditing period, even allowing for practicalities of imperfect synchronization.

Formally: $$\label{eq:workresultfunction}
  \!\!\Xi \colon \left\{\begin{aligned}
    (\mathbb{P}, \N_\mathsf{C}) &\to \mathbb{W} \\
    (p, c) &\mapsto \begin{cases}
        \error &\when \mathbf{o} \not\in \Y \\
        \tup{\is{a}{p_\wpNauthorizer}, \mathbf{o}, \is{x}{p_\wpNcontext}, s, \mathbf{r}} \!\!\!\!\!&\otherwise
    \end{cases}
  \end{aligned}\right.\!\!\!\!\!\!\!$$

where: $$\begin{aligned}
  \mathbf{o} &= \Psi_I(p, c) \\
  (\mathbf{r}, \overline{\mathbf{e}}) &= \transpose[
    (C(p_\wpNworkitems[j], r), \mathbf{e})
    \mid
    (r, \mathbf{e}) = I(p, j),
    j \orderedin \N_{|p_\wpNworkitems|}
  ] \\
  I(p, j) &\equiv R(
    p,
    p_\wpNworkitems[j],
    \sum_{k < j}p_\wpNworkitems[k]_\wiNexportsegments
  )\\
  R(p, w, \ell) &\equiv \\
  &\!\!\!\!\!\!\!\Psi_R(
    w_c,
    w_g,
    w_s,
    \mathcal{H}(p),
    w_\mathbf{y},
    p_\wpNcontext,
    p_\wpNauthorizer,
    M(w),
    X(w),
    \ell
  )\end{aligned}$$

The definition here is staged over several functions for ease of reading. The first term to be introduced, $\mathbf{o}$ is the authorization output, the result of the Is-Authorized function. The second term, $(\mathbf{r}, \overline{\mathbf{e}})$ is the sequence of results for each of the work-items in the work-package together with all segments exported by each work-item.

The third and forth definition are helper terms for this, with the third $I$ performing an ordered accumulation (i.e. counter) in order to ensure that the Refine function has access to the total number of exports made from the work-package up to the current work-item. The fourth term, $R$, is essentially just a call to the Refine function, marshalling the relevant data from the work-package and work-item.

The above relies on two functions, $M$ and $X$ which, respectively, define the import segment data and the extrinsic data for some work-item argument $w$: $$\begin{aligned}
    M(w\in \mathbb{I}) &\equiv [\mathbf{s}[n] \mid (\mathcal{M}(\mathbf{s}), n) \orderedin w_\wiNimportsegments] \\
    X(w\in \mathbb{I}) &\equiv [\mathbf{d} \mid (\mathcal{H}(\mathbf{d}), |\mathbf{d}|) \orderedin w_\wiNextrinsics]
  \end{aligned}$$

We may then define $s$ as the data availability specification of the package using these two functions together with the yet to be defined *Availability Specifier* function $A$ (see section [14.4.1](#sec:availabiltyspecifier){reference-type="ref" reference="sec:availabiltyspecifier"}): $$\begin{aligned}
    s &= A(\mathcal{H}(p), \se(p, \mathbf{x}, \mathbf{i}, \mathbf{j}), \wideparen{\overline{\mathbf{e}}}) \\
    \where \mathbf{x} &= [X(w) \mid w\orderedin p_\wpNworkitems]\\
    \also \mathbf{i} &= [M(w) \mid w\orderedin p_\wpNworkitems]\\
    \also \mathbf{j} &= [\var{\mathcal{J}(\mathbf{s}, n)} \mid (\mathcal{M}(\mathbf{s}), n) \orderedin w_\wiNimportsegments, w\orderedin p_\wpNworkitems]
  \end{aligned}$$

Note that while $M$ and $\mathbf{j}$ are both formulated using the term $\mathbf{s}$ (all segments exported by all work-packages exporting a segment to be imported) such a vast amount of data is not generally needed as the justification can be derived through a single paged-proof. This reduces the worst case data fetching for a guarantor to two segments for every one to be imported. In the case that contiguously exported segments are imported (which we might assume is a fairly common situation), then a single proof-page should be sufficient to justify many imported segments.

Also of note is the lack of length prefixes: only the Merkle paths for the justifications (i.e. the elements of $\mathbf{j}$) have a length prefix. All other sequence lengths are determinable through the work package itself.

The Is-Authorized logic it references is first executed to ensure that the work-package warrants the needed core-time. Next, the guarantor should ensure that all segment-tree roots which form imported segment commitments are known and have not expired. Finally, the guarantor should ensure that they can fetch all preimage data referenced as the commitments of extrinsic segments.

Once done, then imported segments must be reconstructed. This process may in fact be lazy as the Refine function makes no usage of the data until the *import* host-call is made. Fetching generally implies that, for each imported segment, erasure-coded chunks are retrieved from enough unique validators (342, including the guarantor) and is described in more depth in appendix [31](#sec:erasurecoding){reference-type="ref" reference="sec:erasurecoding"}. (Since we specify systematic erasure-coding, its reconstruction is trivial in the case that the correct 342 validators are responsive.) Chunks must be fetched for both the data itself and for justification metadata which allows us to ensure that the data is correct.

Validators, in their role as availability assurers, should index such chunks according to the index of the segments-tree whose reconstruction they facilitate. Since the data for segment chunks is so small at 12 bytes, fixed communications costs should be kept to a bare minimum. A good network protocol (out of scope at present) will allow guarantors to specify only the segments-tree root and index together with a Boolean to indicate whether the proof chunk need be supplied. Since we assume at least 341 other validators are online and benevolent, we can assume that the guarantor can compute $\mathbf{i}$ and $\mathbf{j}$ above with confidence, based on the general availability of data committed to with $\mathbf{s}^\clubsuit$, which is specified below.

### 14.4.1 Availability Specifier {#sec:availabiltyspecifier}

We define the availability specifier function $A$, which creates an availability specifier from the package hash, an octet sequence of the audit-friendly work-package bundle (comprising the work-package itself, the extrinsic data and the concatenated import segments along with their proofs of correctness), and the sequence of exported segments: $$\!\!\!A\colon\left\{\,\begin{aligned}
    &\tuple{\H, \Y, \seq{\G}} \to \mathbb{S}\\
    &\tup{h, \mathbf{b},\,\mathbf{s}} \mapsto \tup{
      h,\,
      \is{l}{|\mathbf{b}|},\,
      u,\,
      \is{e}{\mathcal{M}(\mathbf{s})}
    }
  \end{aligned}\right.\!\!\!\!\!$$ $$\begin{aligned}
  \where u &= \mathcal{M}_B(
    [\wideparen{\mathbf{x}} \mid \mathbf{x} \orderedin \transpose[\mathbf{b}^\clubsuit, \mathbf{s}^\clubsuit]]
  )\\
  \also \mathbf{b}^\clubsuit &= \mathcal{H}^\#(\mathcal{C}_{\ceil{\nicefrac{|\mathbf{b}|}{\mathsf{W}_C}}}(\mathcal{P}_{\mathsf{W}_C}(\mathbf{b})))\\
  \also \mathbf{s}^\clubsuit &= \mathcal{M}_B^\#(\transpose\mathcal{C}^\#_6(\mathbf{s} \concat P(\mathbf{s})))\end{aligned}$$

The paged-proofs function $P$, defined earlier in equation [\[eq:pagedproofs\]](#eq:pagedproofs){reference-type="ref" reference="eq:pagedproofs"}, accepts a sequence of segments and returns a sequence of paged-proofs sufficient to justify the correctness of every segment. There are exactly $\ceil{\nicefrac{1}{64}}$ paged-proof segments as the number of yielded segments, each composed of a page of 64 hashes of segments, together with a Merkle proof from the root to the subtree-root which includes those 64 segments.

The functions $\mathcal{M}$ and $\mathcal{M}_B$ are the fixed-depth and simple binary Merkle root functions, defined in equations [\[eq:constantdepthmerkleroot\]](#eq:constantdepthmerkleroot){reference-type="ref" reference="eq:constantdepthmerkleroot"} and [\[eq:simplemerkleroot\]](#eq:simplemerkleroot){reference-type="ref" reference="eq:simplemerkleroot"}. The function $\mathcal{C}$ is the erasure-coding function, defined in appendix [31](#sec:erasurecoding){reference-type="ref" reference="sec:erasurecoding"}.

And $\mathcal{P}$ is the zero-padding function to take an octet array to some multiple of $n$ in length: $$\label{eq:zeropadding}
  \mathcal{P}_{n \in \N_{1\dots}}\colon\left\{\begin{aligned}
    \Y &\to \Y_{k\cdot n}\\
    \mathbf{x} &\mapsto \mathbf{x} \concat [0, 0, ...]_{((|x|+n - 1) \bmod n) + 1 \dots n}
  \end{aligned}\right.$$

Validators are incentivized to distribute each newly erasure-coded data chunk to the relevant validator, since they are not paid for guaranteeing unless a work-report is considered to be *available* by a super-majority of validators. Given our work-package $\mathbf{p}$, we should therefore send the corresponding work-package bundle chunk and exported segments chunks to each validator whose keys are together with similarly corresponding chunks for imported, extrinsic and exported segments data, such that each validator can justify completeness according to the work-report's *erasure-root*. In the case of a coming epoch change, they may also maximize expected reward by distributing to the new validator set.

We will see this function utilized in the next sections, for guaranteeing, auditing and judging.

# 15 Guaranteeing {#sec:guaranteeing}

Guaranteeing work-packages involves the creation and distribution of a corresponding *work-report* which requires certain conditions to be met. Along with the report, a signature demonstrating the validator's commitment to its correctness is needed. With two guarantor signatures, the work-report may be distributed to the forthcoming JAM chain block author in order to be used in the $\xtguarantees$, which leads to a reward for the guarantors.

We presume that in a public system, validators will be punished severely if they malfunction and commit to a report which does not faithfully represent the result of $\Xi$ applied on a work-package. Overall, the process is:

1.  Evaluation of the work-package's authorization, and cross-referencing against the authorization pool in the most recent JAM chain state.

2.  Creation and publication of a work-package report.

3.  Chunking of the work-package and each of its extrinsic and exported data, according to the erasure codec.

4.  Distributing the aforementioned chunks across the validator set.

5.  Providing the work-package, extrinsic and exported data to other validators on request is also helpful for optimal network performance.

For any work-package $\mathbf{p}$ we are in receipt of, we may determine the work-report, if any, it corresponds to for the core $c$ that we are assigned to. When JAM chain state is needed, we always utilize the chain state of the most recent block.

For any guarantor of index $v$ assigned to core $c$ and a work-package $p$, we define the work-report $r$ simply as: $$r = \Xi(p, c)$$

Such guarantors may safely create and distribute the payload $(s, v)$. The component $s$ may be created according to equation [\[eq:guarantorsig\]](#eq:guarantorsig){reference-type="ref" reference="eq:guarantorsig"}; specifically it is a signature using the validator's registered Ed25519 key on a payload $l$: $$l = \mathcal{H}(c, r)$$

To maximize profit, the guarantor should require the work result meets all expectations which are in place during the guarantee extrinsic described in section [11.4](#sec:workreportguarantees){reference-type="ref" reference="sec:workreportguarantees"}. This includes contextual validity, inclusion of the authorization in the authorization pool, and ensuring total gas is at most $\mathsf{G}_A$. No doing so does not result in punishment, but will prevent the block author from including the package and so reduces rewards.

Advanced nodes may maximize the likelihood that their reports will be includable on-chain by attempting to predict the state of the chain at the time that the report will get to the block author. Naive nodes may simply use the current chain head when verifying the work-report. To minimize work done, nodes should make all such evaluations *prior* to evaluating the $\Psi_R$ function to calculate the report's work results.

Once evaluated as a reasonable work-package to guarantee, guarantors should maximize the chance that their work is not wasted by attempting to form consensus over the core. To achieve this they should send the work-package to any other guarantors on the same core which they do not believe already know of it.

In order to minimize the work for block authors and thus maximize expected profits, guarantors should attempt to construct their core's next guarantee extrinsic from the work-report, core index and set of attestations including their own and as many others as possible.

In order to minimize the chance of any block authors disregarding the guarantor for anti-spam measures, guarantors should sign an average of no more than two work-reports per timeslot.

# 16 Availability Assurance {#sec:assurance}

Validators should issue a signed statement, called an *assurance*, when they are in possession of all of their corresponding erasure-coded chunks for a given work-report which is currently pending availability. For any work-report to gain an assurance, there are two classes of data a validator must have:

Firstly, their erasure-coded chunk for this report's bundle. The validity of this chunk can be trivially proven through the work-report's work-package erasure-root and a Merkle-proof of inclusion in the correct location. The proof should be included from the guarantor. This chunk is needed to verify the work-report's validity and completeness and need not be retained after the work-report is considered audited. Until then, it should be provided on request to validators.

Secondly, the validator should have in hand the corresponding erasure-coded chunk for each of the exported segments referenced by the *segments root*. These should be retained for 28 days and provided to any validator on request.

# 17 Auditing and Judging {#sec:auditing}

The auditing and judging system is theoretically equivalent to that in [Elves]{.smallcaps}, introduced by [@cryptoeprint:2024/961]. For a full security analysis of the mechanism, see this work. There is a difference in terminology, where the terms *backing*, *approval* and *inclusion* there refer to our guaranteeing, auditing and accumulation, respectively.

## 17.1 Overview {#overview}

The auditing process involves each node requiring themselves to fetch, evaluate and issue judgement on a random but deterministic set of work-reports from each JAM chain block in which the work-report becomes available (i.e. from $\mathbf{W}$). Prior to any evaluation, a node declares and proves its requirement. At specific common junctures in time thereafter, the set of work-reports which a node requires itself to evaluate from each block's $\mathbf{W}$ may be enlarged if any declared intentions are not matched by a positive judgement in a reasonable time or in the event of a negative judgement being seen. These enlargement events are called tranches.

If all declared intentions for a work-report are matched by a positive judgement at any given juncture, then the work-report is considered *audited*. Once all of any given block's newly available work-reports are audited, then we consider the block to be *audited*. One prerequisite of a node finalizing a block is for it to view the block as audited. Note that while there will be eventual consensus on whether a block is audited, there may not be consensus at the time that the block gets finalized. This does not affect the crypto-economic guarantees of this system.

In regular operation, no negative judgements will ultimately be found for a work-report, and there will be no direct consequences of the auditing stage. In the unlikely event that a negative judgement is found, then one of several things happens; if there are still more than $\nicefrac{2}{3}\mathsf{V}$ positive judgements, then validators issuing negative judgements may receive a punishment for time-wasting. If there are greater than $\nicefrac{1}{3}\mathsf{V}$ negative judgements, then the block which includes the work-report is ban-listed. It and all its descendants are disregarded and may not be built on. In all cases, once there are enough votes, a judgement extrinsic can be constructed by a block author and placed on-chain to denote the outcome. See section [10](#sec:disputes){reference-type="ref" reference="sec:disputes"} for details on this.

All announcements and judgements are published to all validators along with metadata describing the signed material. On receipt of sure data, validators are expected to update their perspective accordingly (later defined as $J$ and $A$).

## 17.2 Data Fetching

For each work-report to be audited, we use its erasure-root to request erasure-coded chunks from enough assurers. From each assurer we fetch three items (which with a good network protocol should be done under a single request) corresponding to the work-package super-chunks, the self-justifying imports super-chunks and the extrinsic segments super-chunks.

We may validate the work-package reconstruction by ensuring its hash is equivalent to the hash includes as part of the work-package specification in the work-report. We may validate the extrinsic segments through ensuring their hashes are each equivalent to those found in the relevant work-item.

Finally, we may validate each imported segment as a justification must follow the concatenated segments which allows verification that each segment's hash is included in the referencing Merkle root and index of the corresponding work-item.

Exported segments need not be reconstructed in the same way, but rather should be determined in the same manner as with guaranteeing, i.e. through the execution of the Refine logic.

All items in the work-package specification field of the work-report should be recalculated from this now known-good data and verified, essentially retracing the guarantors steps and ensuring correctness.

## 17.3 Selection of Reports

Each validator shall perform auditing duties on each valid block received. Since we are entering off-chain logic, and we cannot assume consensus, we henceforth consider ourselves a specific validator of index $v$ and assume ourselves focused on some block $\mathbf{B}$ with other terms corresponding, so $\sigma'$ is said block's posterior state, $\mathbf{H}$ is its header &c. Practically, all considerations must be replicated for all blocks and multiple blocks' considerations may be underway simultaneously.

We define the sequence of work-reports which we may be required to audit as $\mathbf{Q}$, a sequence of length equal to the number of cores, which functions as a mapping of core index to a work-report pending which has just become available, or $\none$ if no report became available on the core. Formally: $$\begin{aligned}
\label{eq:auditselection}
  \mathbf{Q} &\in \seq{\mathbb{W}?}_\mathsf{C} \\
  \mathbf{Q} &\equiv \left[\begin{rcases}
    \rho[c]_w &\when \rho[c]_w \in \mathbf{W} \\
    \none &\otherwise
  \end{rcases} \,\middle\vert\,c \orderedin \N_\mathsf{C}\right]\end{aligned}$$

We define our initial audit tranche in terms of a verifiable random quantity $s_0$ created specifically for it: $$\begin{aligned}
  s_0 &\in \bandersig{\kappa[v]_b}{\mathsf{X}_U \concat \banderout{\mathbf{H}_v}}{[]} \\
  \mathsf{X}_U &= \token{\$jam\_audit}\end{aligned}$$

We may then define $\mathbf{a}_0$ as the non-empty items to audit through a verifiably random selection of ten cores: $$\begin{aligned}
  \mathbf{a}_0 &= \{\tup{c, w} \mid \tup{c, w} \in \mathbf{p}_{\dots+10}, w \ne \none\} \\
  \where \mathbf{p} &= \mathcal{F}([\tup{c, \mathbf{Q}_c} \mid c \orderedin \N_\mathsf{C}], r) \\
  \also r &= \banderout{s_0}\end{aligned}$$

Every $\mathsf{A} = 8$ seconds following a new time slot, a new tranche begins, and we may determine that additional cores warrant an audit from us. Such items are defined as $\mathbf{a}_n$ where $n$ is the current tranche. Formally: $$\using n = \ffrac{\mathcal{T} - \mathsf{P}\cdot\tau'}{\mathsf{A}}$$

New tranches may contain items from $\mathbf{Q}$ stemming from one of two reasons: either a negative judgement has been received; or the number of judgements from the previous tranche is less than the number of announcements from said tranche. In the first case, the validator is always required to issue a judgement on the work-report. In the second case, a new special-purpose [vrf]{.smallcaps} must be constructed to determine if an audit and judgement is warranted from us.

In all cases, we publish a signed statement of which of the cores we believe we are required to audit (an *announcement*) together with evidence of the [vrf]{.smallcaps} signature to select them and the other validators' announcements from the previous tranche unmatched with a judgement in order that all other validators are capable of verifying the announcement. *Publication of an announcement should be taken as a contract to complete the audit regardless of any future information.*

Formally, for each tranche $n$ we ensure the announcement statement is published and distributed to all other validators along with our validator index $v$, evidence $s_n$ and all signed data. Validator's announcement statements must be in the set: $$\begin{aligned}
  &\sig{\kappa[v]_e}{\mathsf{X}_I \doubleplus n \concat \se([\se_2(c) \frown \mathbf{H}(w) \mid \tup{c, w} \in \mathbf{a}_0])} \\
  &\mathsf{X}_I = \token{\$jam\_announce}\end{aligned}$$

We define $A_n$ as our perception of which validator is required to audit each of the work-reports (identified by their associated core) at tranche $n$. This comes from each other validators' announcements (defined above). It cannot be correctly evaluated until $n$ is current. We have absolute knowledge about our own audit requirements. $$\begin{aligned}
  A_n: \mathbb{W} &\to \powset{\N_\mathsf{V}} \\
  \forall (c, w) &\in \mathbf{a}_0 : v \in q_0(w)\end{aligned}$$

We further define $J_\top$ and $J_\bot$ to be the validator indices who we know to have made respectively, positive and negative, judgements mapped from each work-report's core. We don't care from which tranche a judgement is made. $$\begin{aligned}
  J_{\{\bot, \top\}}: \mathbb{W} \to \powset{\N_\mathsf{V}}\end{aligned}$$

We are able to define $\mathbf{a}_n$ for tranches beyond the first on the basis of the number of validators who we know are required to conduct an audit yet from whom we have not yet seen a judgement. It is possible that the late arrival of information alters $\mathbf{a}_n$ and nodes should reevaluate and act accordingly should this happen.

We can thus define $\mathbf{a}_n$ beyond the initial tranche through a new [vrf]{.smallcaps} which acts upon the set of *no-show* validators. $$\begin{aligned}
  \nonumber&\!\!\!\!\!\!\!\!\forall n > 0:\\
  &\ s_n(w) \in \bandersig{\kappa[v]_b}{\mathsf{X}_U \concat \banderout{\mathbf{H}_v}\concat\mathcal{H}(w)\doubleplus n}{[]} \\
  &\ \mathbf{a}_n \equiv \{ w \in \mathbf{Q} \mid \textstyle\frac{\mathsf{V}}{256\mathsf{F}}\banderout{s_n(w)}_0 < |A_{n - 1}(w) \setminus J_\top(w)| \}\!\!\!\!\end{aligned}$$

We define our bias factor $\mathsf{F} = 2$, which is the expected number of validators which will be required to issue a judgement for a work-report given a single no-show in the tranche before. Modeling by [@cryptoeprint:2024/961] shows that this is optimal.

Later audits must be announced in a similar fashion to the first. If audit requirements lessen on the receipt of new information (i.e. a positive judgement being returned for a previous *no-show*), then any audits already announced are completed and judgements published. If audit requirements raise on the receipt of new information (i.e. an additional announcement being found without an accompanying judgement), then we announce the additional audit(s) we will undertake.

As $n$ increases with the passage of time $\mathbf{a}_n$ becomes known and defines our auditing responsibilities. We must attempt to reconstruct all work-packages and their requisite data corresponding to each work-report we must audit. This may be done through requesting erasure-coded chunks from one-third of the validators. It may also be short-cutted through asking a cooperative third-party (e.g. an original guarantor) for the preimages.

Thus, for any such work-report $w$ we are assured we will be able to fetch some candidate work-package encoding $F(w)$ which comes either from reconstructing erasure-coded chunks verified through the erasure coding's Merkle root, or alternatively from the preimage of the work-package hash. We decode this candidate blob into a work-package.

In addition to the work-package, we also assume we are able to fetch all manifest data associated with it through requesting and reconstructing erasure-coded chunks from one-third of validators in the same way as above.

We then attempt to reproduce the report on the core to give $e_n$, a mapping from cores to evaluations: $$\begin{aligned}
  %  \forall (c, w) \in \mathbf{a}_n \!: e_n(w) \!\Leftrightarrow\! \begin{cases}
  %    w = \Xi(p, c)\!\!\!\!\! &\when \exists p \in \mathbb{P}: \se(p) = F(w) \\
  %    \bot &\otherwise
  %  \end{cases}
    \forall (c, w) \in \mathbf{a}_n :\ \ &\\[-10pt]
    e_n(w) \Leftrightarrow &\begin{cases}
      w = \Xi(p, c)\!\!\! &\when \exists p \in \mathbb{P}: \se(p) = F(w) \\
      \bot &\otherwise
    \end{cases}
  \end{aligned}\!\!$$

Note that a failure to decode implies an invalid work-report.

From this mapping the validator issues a set of judgements $\mathbf{j}_n$: $$\begin{aligned}
  \mathbf{j}_n &= \{ \mathcal{S}_{\kappa[v]_e}(\mathsf{X}_{e(w)} \concat \mathcal{H}(w)) \mid (c, w) \in \mathbf{a}_n \}\end{aligned}$$

All judgements $\mathbf{j}_*$ should be published to other validators in order that they build their view of $J$ and in the case of a negative judgement arising, can form an extrinsic for $\xtdisputes$.

We consider a work-report as audited under two circumstances. Either, when it has no negative judgements and there exists some tranche in which we see a positive judgement from all validators who we believe are required to audit it; or when we see positive judgements for it from greater than two-thirds of the validator set. $$\begin{aligned}
%  U(w) &\Leftrightarrow J_\bot(w) = \emptyset \wedge \exists n : A_n(w) \subset J_\top(w) \vee |J_\top(w)| > \nicefrac{2}{3}\mathsf{V}%\!\!\!\!\!\!\!\!\!\!\!\!\!\!
  U(w) &\Leftrightarrow \bigvee\,\left\{\,\begin{aligned}
      &J_\bot(w) = \emptyset \wedge \exists n : A_n(w) \subset J_\top(w) \\
      &|J_\top(w)| > \nicefrac{2}{3}\mathsf{V}
  \end{aligned}\right.\end{aligned}$$

Our block $\mathbf{B}$ may be considered audited, a condition denoted $\mathbf{U}$, when all the work-reports which were made available are considered audited. Formally: $$\begin{aligned}
  \mathbf{U} &\Leftrightarrow \forall w \in \mathbf{W} : U(w)\end{aligned}$$

For any block we must judge it to be audited (i.e. $\mathbf{U} = \top$) before we vote for the block to be finalized in [Grandpa]{.smallcaps}. See section [\[sec:grandpa\]](#sec:grandpa){reference-type="ref" reference="sec:grandpa"} for more information here.

Furthermore, we pointedly disregard chains which include the accumulation of a report which we know at least $\nicefrac{1}{3}$ of validators judge as being invalid. Any chains including such a block are not eligible for authoring on. The *best block*, i.e. that on which we build new blocks, is defined as the chain with the most regular Safrole blocks which does *not* contain any such disregarded block. Implementation-wise, this may require reversion to an earlier head or alternative fork.

As a block author, we include a judgement extrinsic which collects judgement signatures together and reports them on-chain. In the case of a non-valid judgement (i.e. one which is not two-thirds-plus-one of judgements confirming validity) then this extrinsic will be introduced in a block in which accumulation of the non-valid work-report is about to take place. The non-valid judgement extrinsic removes it from the pending work-reports, $\rho$. Refer to section [10](#sec:disputes){reference-type="ref" reference="sec:disputes"} for more details on this.

# 18 Beefy Distribution {#sec:beefy}

For each finalized block $\mathbf{B}$ which a validator imports, said validator shall make a [bls]{.smallcaps} signature on the [bls]{.smallcaps}- curve, as defined by [@bls12-381], affirming the Keccak hash of the block's most recent [Beefy]{.smallcaps} [mmr]{.smallcaps}. This should be published and distributed freely, along with the signed material. These signatures may be aggregated in order to provide concise proofs of finality to third-party systems. The signing and aggregation mechanism is defined fully by [@cryptoeprint:2022/1611].

Formally, let $\mathbf{F}_v$ be the signed commitment of validator index $v$ which will be published: $$\begin{aligned}
\label{eq:beefysignedcommitment}
  \mathbf{F}_v &\equiv \mathcal{S}_{\kappa'_v}(\mathsf{X}_B\concat\mathcal{H}_K(\se_M(\text{last}(\beta)_\mathbf{b}]))\\
  \mathsf{X}_B &= \token{\$jam\_beefy}\end{aligned}$$

# 19 Grandpa and the Best Chain {#sec:bestchain}

[]{#sec:grandpa label="sec:grandpa"}

Nodes take part in the [Grandpa]{.smallcaps} protocol as defined by [@stewart2020grandpa].

We define the latest finalized block as $\mathbf{B}^\natural$. All associated terms concerning block and state are similarly superscripted. We consider the *best block*, $\mathbf{B}^\flat$ to be that which is drawn from the set of acceptable blocks of the following criteria:

-   Has the finalized block as an ancestor.

-   Contains no unfinalized blocks where we see an equivocation (two valid blocks at the same timeslot).

-   Is considered audited.

Formally: $$\begin{aligned}
  \mathbf{A}(\mathbf{H}^\flat) &\owns \mathbf{H}^\natural\\
  \mathbf{U}^\flat&\equiv \top \\
  \not\exists \mathbf{H}^A, \mathbf{H}^B &: \bigwedge \left\{\,\begin{aligned}
    \mathbf{H}^A &\ne \mathbf{H}^B \\
    \mathbf{H}^A_T &= \mathbf{H}^B_T \\
    \mathbf{H}^A &\in \mathbf{A}(\mathbf{H}^\flat) \\
    \mathbf{H}^A &\not\in \mathbf{A}(\mathbf{H}^\natural)
  \end{aligned}\right.\end{aligned}$$

Of these acceptable blocks, that which contains the most ancestor blocks whose author used a seal-key ticket, rather than a fallback key should be selected as the best head, and thus the chain on which the participant should make [Grandpa]{.smallcaps} votes.

Formally, we aim to select $\mathbf{B}^\flat$ to maximize the value $m$ where: $$m = \sum_{\mathbf{H}^A \in \mathbf{A}^\flat} \mathbf{T}^A$$

# 20 Discussion {#sec:discussion}

## 20.1 Technical Characteristics

In total, with our stated target of 1,023 validators and three validators per core, along with requiring a mean of ten audits per validator per timeslot, and thus 30 audits per work-report, JAM is capable of trustlessly processing and integrating 341 work-packages per timeslot.

We assume node hardware is a modern 16 core [cpu]{.smallcaps} with 64[gb]{.smallcaps} [ram]{.smallcaps}, 1[tb]{.smallcaps} secondary storage and 0.5[g]{.smallcaps}be networking.

Our performance models assume a rough split of [cpu]{.smallcaps} time as follows:

::: center
                                                  *Proportion*          
  ----------------------------------------------- --------------------- --
  Audits                                          $\nicefrac{10}{16}$   
  Merklization                                    $\nicefrac{1}{16}$    
  Block execution                                 $\nicefrac{2}{16}$    
  [Grandpa]{.smallcaps} and [Beefy]{.smallcaps}   $\nicefrac{1}{16}$    
  Erasure coding                                  $\nicefrac{1}{16}$    
  Networking & misc                               $\nicefrac{1}{16}$    
:::

Estimates for network bandwidth requirements are as follows:

::: center
  ----------------------------------------------- -------------------- --------------------
                                                  *Upload*             *Download*
                                                  [m]{.smallcaps}b/s   [m]{.smallcaps}b/s
  Guaranteeing                                    30                   40
  Assuring                                        60                   56
  Auditing                                        200                  200
  Block publication                               42                   42
  [Grandpa]{.smallcaps} and [Beefy]{.smallcaps}   4                    4
  **Total**                                       **336**              **342**
  ----------------------------------------------- -------------------- --------------------
:::

Thus, a connection able to sustain 500[m]{.smallcaps}b/s should leave a sufficient margin of error and headroom to serve other validators as well as some public connections, though the burstiness of block publication would imply validators are best to ensure that peak bandwidth is higher.

Under these conditions, we would expect an overall network-provided data availability capacity of 2[pb]{.smallcaps}, with each node dedicating at most $6$[tb]{.smallcaps} to availability storage.

Estimates for memory usage are as follows:

::: center
                    [gb]{.smallcaps}   
  ----------------- ------------------ -------------------------------------------
  Auditing          20                 2 $\times$ 10 [pvm]{.smallcaps} instances
  Block execution   2                  1 [pvm]{.smallcaps} instance
  State cache       40                 
  Misc              2                  
  **Total**         **64**             
:::

As a rough guide, each parachain has an average footprint of around 2[mb]{.smallcaps} in the Polkadot Relay chain; a 40[gb]{.smallcaps} state would allow 20,000 parachains' information to be retained in state.

What might be called the "virtual hardware" of a JAM core is essentially a regular [cpu]{.smallcaps} core executing at somewhere between 25% and 50% of regular speed for the whole six-second portion and which may draw and provide 2.5[mb]{.smallcaps}/s average in general-purpose [i/o]{.smallcaps} and utilize up to 2[gb]{.smallcaps} in [ram]{.smallcaps}. The [i/o]{.smallcaps} includes any trustless reads from the JAM chain state, albeit in the recent past. This virtual hardware also provides unlimited reads from a semi-static preimage-lookup database.

Each work-package may occupy this hardware and execute arbitrary code on it in six-second segments to create some result of at most 90[kb]{.smallcaps}. This work result is then entitled to 10ms on the same machine, this time with no "external" [i/o]{.smallcaps} beyond said result, but instead with full and immediate access to the JAM chain state and may alter the service(s) to which the results belong.

## 20.2 Illustrating Performance

In terms of pure processing power, the JAM machine architecture can deliver extremely high levels of homogeneous trustless computation. However, the core model of JAM is a classic parallelized compute architecture, and for solutions to be able to utilize the architecture well they must be designed with it in mind to some extent. Accordingly, until such use-cases appear on JAM with similar semantics to existing ones, it is very difficult to make direct comparisons to existing systems. That said, if we indulge ourselves with some assumptions then we can make some crude comparisons.

### 20.2.1 Comparison to Polkadot

Pre-asynchronous backing, Polkadot validates around 50 parachains, each one utilizing approximately 250ms of native computation (i.e. half a second of Wasm execution time at around a 50% overhead) and 5[mb]{.smallcaps} of [i/o]{.smallcaps} for every twelve seconds of real time which passes. This corresponds to an aggregate compute performance of around parity with a native [cpu]{.smallcaps} core and a total 24-hour distributed availability of around 20[mb]{.smallcaps}/s. Accumulation is beyond Polkadot's capabilities and so not comparable.

Post asynchronous-backing and estimating that Polkadot is at present capable of validating at most 80 parachains each doing one second of native computation in every six, then the aggregate performance is increased to around 13x native [cpu]{.smallcaps} and the distributed availability increased to around 67[mb]{.smallcaps}/s.

For comparison, in our basic models, JAM should be capable of attaining around 85x the computation load of a single native [cpu]{.smallcaps} core and a distributed availability of 852[mb]{.smallcaps}/s.

### 20.2.2 Simple Transfers

We might also attempt to model a simple transactions-per-second amount, with each transaction requiring a signature verification and the modification of two account balances. Once again, until there are clear designs for precisely how this would work we must make some assumptions. Our most naive model would be to use the JAM cores (i.e. refinement) simply for transaction verification and account lookups. The JAM chain would then hold and alter the balances in its state. This is unlikely to give great performance since almost all the needed [i/o]{.smallcaps} would be synchronous, but it can serve as a basis.

A 15[mb]{.smallcaps} work-package can hold around 125k transactions at 128 bytes per transaction. However, a 90[kb]{.smallcaps} work-result could only encode around 11k account updates when each update is given as a pair of a 4 byte account index and 4 byte balance, resulting in a limit of 5.5k transactions per package, or 312k [tps]{.smallcaps} in total. It is possible that the eight bytes could typically be compressed by a byte or two, increasing maximum throughput a little. Our expectations are that state updates, with highly parallelized Merklization, can be done at between 500k and 1 million reads/write per second, implying around 250k-350k [tps]{.smallcaps}, depending on which turns out to be the bottleneck.

A more sophisticated model would be to use the JAM cores for balance updates as well as transaction verification. We would have to assume that state and the transactions which operate on them can be partitioned between work-packages with some degree of efficiency, and that the 15[mb]{.smallcaps} of the work-package would be split between transaction data and state witness data. Our basic models predict that a 4bn 32-bit account system paginated into $2^{10}$ accounts/page and 128 bytes per transaction could, assuming only around 1% of oraclized accounts were useful, average upwards of 1.7m[tps]{.smallcaps} depending on partitioning and usage characteristics. Partitioning could be done with a fixed fragmentation (essentially sharding state), a rotating partition pattern or a dynamic partitioning (which would require specialized sequencing).

Interestingly, we expect neither model to be bottlenecked in computation, meaning that transactions could be substantially more sophisticated, perhaps with more flexible cryptography or smart contract functionality, without a significant impact on performance.

### 20.2.3 Computation Throughput

The [tps]{.smallcaps} metric does not lend itself well to measuring distributed systems' computational performance, so we now turn to another slightly more compute-focussed benchmark: the [evm]{.smallcaps}. The basic *YP* Ethereum network, now approaching a decade old, is probably the best known example of general purpose decentralized computation and makes for a reasonable yardstick. It is able to sustain a computation and [i/o]{.smallcaps} rate of 1.25M gas/sec, with a peak throughput of twice that. The [evm]{.smallcaps} gas metric was designed to be a time-proportional metric for predicting and constraining program execution. Attempting to determine a concrete comparison to [pvm]{.smallcaps} throughput is non-trivial and necessarily opinionated owing to the disparity between the two platforms including word size, endianness and stack/register architecture and memory model. However, we will attempt to determine a reasonable range of values.

[Evm]{.smallcaps} gas does not directly translate into native execution as it also combines state reads and writes as well as transaction input data, implying it is able to process some combination of up to 595 storage reads, 57 storage writes and 1.25M gas as well as 78[kb]{.smallcaps} input data in each second, trading one against the other.[^13] We cannot find any analysis of the typical breakdown between storage [i/o]{.smallcaps} and pure computation, so to make a very conservative estimate, we assume it does all four. In reality, we would expect it to be able to do on average of each.

Our experiments[^14] show that on modern, high-end consumer hardware with a modern [evm]{.smallcaps} implementation, we can expect somewhere between 100 and 500 gas/µs in throughput on pure-compute workloads (we specifically utilized Odd-Product, Triangle-Number and several implementations of the Fibonacci calculation). To make a conservative comparison to [pvm]{.smallcaps}, we propose transcompilation of the [evm]{.smallcaps} code into [pvm]{.smallcaps} code and then re-execution of it under the Polka[vm]{.smallcaps} prototype.[^15]

To help estimate a reasonable lower-bound of [evm]{.smallcaps} gas/µs, e.g. for workloads which are more memory and [i/o]{.smallcaps} intensive, we look toward real-world permissionless deployments of the [evm]{.smallcaps} and see that the Moonbeam network, after correcting for the slowdown of executing within the recompiled WebAssembly platform on the somewhat conservative Polkadot hardware platform, implies a throughput of around 100 gas/µs. We therefore assert that in terms of computation, 1µs [evm]{.smallcaps} gas approximates to around 100-500 gas on modern high-end consumer hardware.[^16]

Benchmarking and regression tests show that the prototype [pvm]{.smallcaps} engine has a fixed preprocessing overhead of around 5ns/byte of program code and, for arithmetic-heavy tasks at least, a marginal factor of 1.6-2% compared to [evm]{.smallcaps} execution, implying an asymptotic speedup of around 50-60x. For machine code 1[mb]{.smallcaps} in size expected to take of the order of a second to compute, the compilation cost becomes only 0.5% of the overall time. [^17] For code not inherently suited to the 256-bit [evm]{.smallcaps} [isa]{.smallcaps}, we would expect substantially improved relative execution times on [pvm]{.smallcaps}, though more work must be done in order to gain confidence that these speed-ups are broadly applicable.

If we allow for preprocessing to take up to the same component within execution as the marginal cost (owing to, for example, an extremely large but short-running program) and for the [pvm]{.smallcaps} metering to imply a safety overhead of 2x to execution speeds, then we can expect a JAM core to be able to process the equivalent of around 1,500 [evm]{.smallcaps} gas/µs. Owing to the crudeness of our analysis we might reasonably predict it to be somewhere within a factor of three either way---i.e. 500-5,000 [evm]{.smallcaps} gas/µs.

JAM cores are each capable of 2.5[mb]{.smallcaps}/s bandwidth, which must include any state [i/o]{.smallcaps} and data which must be newly introduced (e.g. transactions). While writes come at comparatively little cost to the core, only requiring hashing to determine an eventual updated Merkle root, reads must be witnessed, with each one costing around 640 bytes of witness conservatively assuming a one-million entry binary Merkle trie. This would result in a maximum of a little under 4k reads/second/core, with the exact amount dependent upon how much of the bandwidth is used for newly introduced input data.

Aggregating everything across JAM, excepting accumulation which could add further throughput, numbers can be multiplied by 341 (with the caveat that each one's computation cannot interfere with any of the others' except through state oraclization and accumulation). Unlike for *roll-up chain* designs such as Polkadot and Ethereum, there is no need to have persistently fragmented state. Smart-contract state may be held in a coherent format on the JAM chain so long as any updates are made through the 15[kb]{.smallcaps}/core/sec work results, which would need to contain only the hashes of the altered contracts' state roots.

Under our modelling assumptions, we can therefore summarize:

::: center
                                       Eth. L1                          JAM Core                           JAM
  ------------------------------------ -------------------------------- ---------------------------------- ----------------------------------
  Compute ([evm]{.smallcaps} gas/µs)   $1.25^\dagger$                   500-5,000                          0.15-1.5[m]{.smallcaps}
  State writes (s$^{-1}$)              $57^\dagger$                     n/a                                n/a
  State reads (s$^{-1}$)               $595^\dagger$                    4[k]{.smallcaps}${}^\ddagger$      1.4[m]{.smallcaps}${}^\ddagger$
  Input data (s$^{-1}$)                78[kb]{.smallcaps}${}^\dagger$   2.5[mb]{.smallcaps}${}^\ddagger$   852[mb]{.smallcaps}${}^\ddagger$
:::

What we can see is that JAM's overall predicted performance profile implies it could be comparable to many thousands of that of the basic Ethereum L1 chain. The large factor here is essentially due to three things: spacial parallelism, as JAM can host several hundred cores under its security apparatus; temporal parallelism, as JAM targets continuous execution for its cores and pipelines much of the computation between blocks to ensure a constant, optimal workload; and platform optimization by using a [vm]{.smallcaps} and gas model which closely fits modern hardware architectures.

It must however be understood that this is a provisional and crude estimation only. It is included for only the purpose of expressing JAM's performance in tangible terms and is not intended as a means of comparing to a "full-blown" Ethereum/L2-ecosystem combination. Specifically, it does not take into account:

-   that these numbers are based on real performance of Ethereum and performance modelling of JAM (though our models are based on real-world performance of the components);

-   any L2 scaling which may be possible with either JAM or Ethereum;

-   the state partitioning which uses of JAM would imply;

-   the as-yet unfixed gas model for the [pvm]{.smallcaps};

-   that [pvm]{.smallcaps}/[evm]{.smallcaps} comparisons are necessarily imprecise;

-   (${}^\dagger$) all figures for Ethereum L1 are drawn from the same resource: on average each figure will be only $\nicefrac{1}{4}$ of this maximum.

-   (${}^\ddagger$) the state reads and input data figures for JAM are drawn from the same resource: on average each figure will be only $\nicefrac{1}{2}$ of this maximum.

We leave it as further work for an empirical analysis of performance and an analysis and comparison between JAM and the aggregate of a hypothetical Ethereum ecosystem which included some maximal amount of L2 deployments together with full Dank-sharding and any other additional consensus elements which they would require. This, however, is out of scope for the present work.

# 21 Conclusion {#sec:conclusion}

We have introduced a novel computation model which is able to make use of pre-existing crypto-economic mechanisms in order to deliver major improvements in scalability without causing persistent state-fragmentation and thus sacrificing overall cohesion. We call this overall pattern collect-refine-join-accumulate. Furthermore, we have formally defined the on-chain portion of this logic, essentially the join-accumulate portion. We call this protocol the JAM chain.

We argue that the model of JAM provides a novel "sweet spot", allowing for massive amounts of computation to be done in secure, resilient consensus compared to fully-synchronous models, and yet still have strict guarantees about both timing and integration of the computation into some singleton state machine unlike persistently fragmented models.

## 21.1 Further Work

While we are able to estimate theoretical computation possible given some basic assumptions and even make broad comparisons to existing systems, practical numbers are invaluable. We believe the model warrants further empirical research in order to better understand how these theoretical limits translate into real-world performance. We feel a proper cost analysis and comparison to pre-existing protocols would also be an excellent topic for further work.

We can be reasonably confident that the design of JAM allows it to host a service under which Polkadot *parachains* could be validated, however further prototyping work is needed to understand the possible throughput which a [pvm]{.smallcaps}-powered metering system could support. We leave such a report as further work. Likewise, we have also intentionally omitted details of higher-level protocol elements including cryptocurrency, coretime sales, staking and regular smart-contract functionality.

A number of potential alterations to the protocol described here are being considered in order to make practical utilization of the protocol easier. These include:

-   Synchronous calls between services in accumulate.

-   Restrictions on the `transfer` function in order to allow for substantial parallelism over accumulation.

-   The possibility of reserving substantial additional computation capacity during accumulate under certain conditions.

-   Introducing Merklization into the Work Package format in order to obviate the need to have the whole package downloaded in order to evaluate its authorization.

The networking protocol is also left intentionally undefined at this stage and its description must be done in a follow-up proposal.

Validator performance is not presently tracked on-chain. We do expect this to be tracked on-chain in the final revision of the JAM protocol, but its specific format is not yet certain and it is therefore omitted at present.

# 22 Acknowledgements

Much of this present work is based in large part on the work of others. The Web3 Foundation research team and in particular Alistair Stewart and Jeff Burdges are responsible for [Elves]{.smallcaps}, the security apparatus of Polkadot which enables the possibility of in-core computation for JAM. The same team is responsible for Sassafras, [Grandpa]{.smallcaps} and [Beefy]{.smallcaps}.

Safrole is a mild simplification of Sassafras and was made under the careful review of Davide Galassi and Alistair Stewart.

The original CoreJam [rfc]{.smallcaps} was refined under the review of Bastian Köcher and Robert Habermeier and most of the key elements of that proposal have made their way into the present work.

The [pvm]{.smallcaps} is a formalization of a partially simplified *PolkaVM* software prototype, developed by Jan Bujak. Cyrill Leutwiler contributed to the empirical analysis of the [pvm]{.smallcaps} reported in the present work.

The *PolkaJam* team and in particular Arkadiy Paronyan, Emeric Chevalier and Dave Emett have been instrumental in the design of the lower-level aspects of the JAM protocol, especially concerning Merklization and [i/o]{.smallcaps}.

Numerous contributors to the repository since publication have helped correct errors. Thank you to all.

And, of course, thanks to the awesome Lemon Jelly, a.k.a. Fred Deakin and Nick Franglen, for three of the most beautiful albums ever produced, the cover art of the first of which was inspiration for this paper's background art.
:::

# A Polka Virtual Machine {#sec:virtualmachine}

## A.1 Basic Definition {#basic-definition}

We declare the general [pvm]{.smallcaps} function $\Psi$. We assume a single-step invocation function define $\Psi_1$ and define the full [pvm]{.smallcaps} recursively as a sequence of such mutations up until the single-step mutation results in a halting condition. $$\Psi\colon \left\{\begin{aligned}
    (\Y, \N_R, \N_G, \seq{\N_R}_{13}, \mathbb{M}) &\to (\{\halt, \panic, \oog\} \cup \{\fault\} \times \N_R \cup \{\host\} \times \N_R, \N_R, \Z_G, \seq{\N_R}_{13}, \mathbb{M})\\
    (\mathbf{p}, \imath, \xi, \omega, {\mu}) &\mapsto \begin{cases}
      \Psi(\mathbf{p}, \imath', \xi', \omega', {\mu}') &\when \varepsilon = \blacktriangleright\\
      (\oog, \imath', \xi', \omega', {\mu}') &\when \xi' < 0\\
      (\varepsilon, \imath', \xi', \omega', {\mu}') &\otherwise
    \end{cases} \\
    \where (\varepsilon, \imath', \xi', \omega', {\mu}') &= \Psi_1(\mathbf{c}, \mathbf{k}, \mathbf{j}, \imath, \xi, \omega, {\mu})\\
    \also \mathbf{p} &= \se(|\mathbf{j}|) \frown \se_1(z) \frown \se(|\mathbf{c}|) \frown \se_z(\mathbf{j}) \frown \se(\mathbf{c}) \frown \se(\mathbf{k})\,,\ |\mathbf{k}| = |\mathbf{c}|
    \end{aligned}\right.$$

If the latter condition cannot be satisfied, then $(\panic, \imath, \xi, \omega, {\mu})$ is the result.

The [pvm]{.smallcaps} exit reason $\varepsilon \in \{\halt, \panic, \oog\} \cup \{\fault, \host\} \times \N_R$ may be one of regular halt $\halt$, panic $\panic$ or out-of-gas $\oog$, or alternatively a host-call $\host$, in which the host-call identifier is associated, or page-fault $\fault$ in which case the address into [ram]{.smallcaps} is associated.

## A.2 Instructions, Opcodes and Skip-distance {#instructions-opcodes-and-skip-distance}

The program blob $\mathbf{p}$ is split into a series of octets which make up the *instruction data* $\mathbf{c}$ and the *opcode bitmask* $\mathbf{k}$ as well as the *dynamic jump table*, $\mathbf{j}$. The former two imply an instruction sequence, and by extension a *basic-block sequence*, itself a sequence of indices of the instructions which follow a *block-termination* instruction.

The latter, dynamic jump table, is a sequence of indices into the instruction data blob and is indexed into when dynamically-computed jumps are taken. It is encoded as a sequence of natural numbers (i.e. non-negative integers) each encoded with the same length in octets. This length, term $z$ above, is itself encoded prior.

The [pvm]{.smallcaps} counts instructions in octet terms (rather than in terms of instructions) and it is thus convenient to define which octets represent the beginning of an instruction, i.e. the opcode octet, and which do not. This is the purpose of $\mathbf{k}$, the instruction-opcode bitmask. We assert that the length of the bitmask is equal to the length of the instruction blob.

We define the Skip function $\text{skip}$ which provides the number of octets, minus one, to the next instruction's opcode, given the index of instruction's opcode index into $\mathbf{c}$ (and by extension $\mathbf{k}$): $$\text{skip}\colon\left\{\begin{aligned}
    \N &\to \N\\
    i &\mapsto \min(24,\ j \in \N : (\mathbf{k} \frown [1, 1, \dots])_{i + 1 + j} = 1)
  \end{aligned}\right.$$

The Skip function appends $\mathbf{k}$ with a sequence of set bits in order to ensure a well-defined result for the final instruction $\text{skip}(|\mathbf{c}| - 1)$.

Given some instruction-index $i$, its opcode is readily expressed as $\mathbf{c}_i$ and the distance in octets to move forward to the next instruction is $1 + \text{skip}(i)$. However, each instruction's "length" (defined as the number of contiguous octets starting with the opcode which are needed to fully define the instruction's semantics) is left implicit though limited to being at most 16.

We define $\zeta$ as being equivalent to the instructions $\mathbf{c}$ except with an indefinite sequence of zeroes suffixed to ensure that no out-of-bounds access is possible. This effectively defines any otherwise-undefined arguments to the final instruction and ensures that a trap will occur if the program counter passes beyond the program code. Formally: $$\label{eq:instructions}
  \zeta\equiv \mathbf{c} \concat \sq{0, 0, \dots}$$

## A.3 Basic Blocks and Termination Instructions {#basic-blocks-and-termination-instructions}

Instructions of the following opcodes are considered basic-block termination instructions; other than $\token{trap}$ & $\token{fallthrough}$, they correspond to instructions which may define the instruction-counter to be something other than its prior value plus the instruction's skip amount:

-   Trap and fallthrough: $\token{trap}$ , $\token{fallthrough}$

-   Jumps: $\token{jump}$ , $\token{jump\_ind}$

-   Load-and-Jumps: $\token{load\_imm\_jump}$ , $\token{load\_imm\_jump\_ind}$

-   Branches: $\token{branch\_eq}$ , $\token{branch\_ne}$ , $\token{branch\_ge\_u}$ , $\token{branch\_ge\_s}$ , $\token{branch\_lt\_u}$ , $\token{branch\_lt\_s}$ , $\token{branch\_eq\_imm}$ , $\token{branch\_ne\_imm}$

-   Immediate branches: $\token{branch\_lt\_u\_imm}$ , $\token{branch\_lt\_s\_imm}$ , $\token{branch\_le\_u\_imm}$ , $\token{branch\_le\_s\_imm}$ , $\token{branch\_ge\_u\_imm}$ , $\token{branch\_ge\_s\_imm}$ , $\token{branch\_gt\_u\_imm}$ , $\token{branch\_gt\_s\_imm}$

We denote this set, as opcode indices rather than names, as $T$. We define the instruction opcode indices denoting the beginning of basic-blocks as $\varpi$: $$\varpi\equiv [0] \concat [n + 1 + \text{skip}(n) \mid n \orderedin \N_{|\mathbf{c}|} \wedge \mathbf{k}_n = 1 \wedge \mathbf{c}_n \in T]$$

## A.4 Single-Step State Transition {#single-step-state-transition}

We must now define the single-step [pvm]{.smallcaps} state-transition function $\Psi_1$: $$\Psi_1\colon \left\{\begin{aligned}
    (\Y, \mathbb{B}, \seq{\N_R}, \N_R, \N_G, \seq{\N_R}_{13}, \mathbb{M}) &\to (\{\panic, \halt, \blacktriangleright\} \cup \{\fault, \host\} \times \N_R, \Z_G, \seq{\N_R}_{13}, \mathbb{M})\\
    (\mathbf{c}, \mathbf{k}, \mathbf{j}, \imath, \xi, \omega, {\mu}) &\mapsto (\varepsilon, \imath', \xi', \omega', {\mu}')
  \end{aligned}\right.$$

We define $\varepsilon$ together with the posterior values (denoted as prime) of each of the items of the machine state as being in accordance with the table below.

In general, when transitioning machine state for an instruction a number of conditions hold true and instructions are defined essentially by their exceptions to these rules. Specifically, the machine does not halt, the instruction counter increments by one, the gas remaining is reduced by the amount corresponding to the instruction type and [ram]{.smallcaps} & registers are unchanged. Formally: $$\varepsilon = \blacktriangleright,\quad \imath' = \imath + 1 + \text{skip}(\imath),\quad \xi' = \xi - \xi_\Delta,\quad \omega' = \omega,\quad{\mu}' = {\mu}\text{ except as indicated }$$

Where [ram]{.smallcaps} must be inspected and yet access is not possible, then machine state is unchanged, and the exit reason is a fault with the lowest address to be read which is inaccessible. More formally, let $\mathbf{a}$ be the set of indices in to which ${\mu}$ must be subscripted in order to calculate the result of $\Psi_1$. If $\mathbf{a} \not\subset \mathbb{V}_{\mu}$ then let $\varepsilon=\fault \times \text{min}(\mathbf{a} \setminus \mathbb{V}_{\mu})$.

Similarly, where [ram]{.smallcaps} must be mutated and yet mutable access is not possible, then machine state is unchanged, and the exit reason is a fault with the lowest address to be read which is inaccessible. More formally, let $\mathbf{a}$ be the set of indices in to which ${\mu}'$ must be subscripted in order to calculate the result of $\Psi_1$. If $\mathbf{a} \not\subset \mathbb{V}^*_{\mu}$ then let $\varepsilon=\fault \times \text{min}(\mathbf{a} \setminus \mathbb{V}^*_{\mu})$.

We define signed/unsigned transitions for various octet widths: $$\begin{aligned}
  \label{eq:signedfunc}
  \mathcal{Z}_{n \in \N}&\colon\left\{\begin{aligned}
    \N_{2^{8n}} &\to \Z_{-2^{8n-1}\dots2^{8n-1}}\\
    a &\mapsto \begin{cases}
      a &\when a < 2^{8n-1} \\
      a -\ 2^{8n} &\otherwise
    \end{cases}
  \end{aligned}\right.\\
  \mathcal{Z}_{n \in \N}^{-1} &\colon\left\{\begin{aligned}
    \Z_{-2^{8n-1}\dots2^{8n-1}} &\to \N_{2^{8n}}\\
    a &\mapsto (2^{8n} + a) \bmod 2^{8n}
  \end{aligned}\right.\\
  \label{eq:bitsfunc}
  \mathcal{B}_{n\in\N}&\colon\left\{\begin{aligned}
    \N_{2^{8n}} &\to \mathbb{B}_{8n}\\
    x &\mapsto \mathbf{y}: \forall i \in \N_{2^{8n}} : \mathbf{y}[i] \Leftrightarrow \ffrac{x}{2^i}\bmod 2
  \end{aligned}\right.\\
  \mathcal{B}_{n\in\N}^{-1}&\colon\left\{\begin{aligned}
    \mathbb{B}_{8n} &\to \N_{2^{8n}}\\
    \mathbf{x} &\mapsto y: \sum_{i \in \N_{2^{8n}}} \mathbf{x}_i \cdot 2^i
  \end{aligned}\right.\end{aligned}$$

Immediate arguments are encoded in little-endian format with the most-significant bit being the sign bit. They may be compactly encoded by eliding more significant octets. Elided octets are assumed to be zero if the [msb]{.smallcaps} of the value is zero, and 255 otherwise. This allows for compact representation of both positive and negative encoded values. We thus define the signed extension function operating on an input of $n$ octets as $\mathcal{X}_n$: $$\begin{aligned}
\label{eq:signedextension}
  \mathcal{X}_{n\in\{0, 1, 2, 3, 4\}}\colon\left\{\begin{aligned}
    \N_{2^{8n}} &\to \N_{2^{32}}\\
    x &\mapsto x + \ffrac{x}{2^{8n-1}}(2^{32}-2^{8n})
  \end{aligned}\right.\end{aligned}$$

Any alterations of the program counter stemming from a static jump, call or branch must be to the start of a basic block or else a panic occurs. Hypotheticals are not considered. Formally: $$\token{branch}(b, C) \implies (\varepsilon, \imath') = \begin{cases}
    (\blacktriangleright, \imath) &\when \lnot C \\
    (\panic, \imath) &\otherwhen b \not\in \varpi\\
    (\blacktriangleright, b) &\otherwise
  \end{cases}$$

Jumps whose next instruction is dynamically computed must use an address which may be indexed into the jump-table $\mathbf{j}$. Through a quirk of tooling[^18], we define the dynamic address required by the instructions as the jump table index incremented by one and then multiplied by our jump alignment factor $\mathsf{Z}_A = 2$.

As with other irregular alterations to the program counter, target code index must be the start of a basic block or else a panic occurs. Formally: $$\label{eq:jumptablealignment}
  \token{djump}(a) \implies (\varepsilon, \imath') = \begin{cases}
    (\halt, \imath) &\when a = 2^{32} - 2^{16}\\
    (\panic, \imath) &\otherwhen a = 0 \vee a > |\mathbf{j}|\cdot\mathsf{Z}_A \vee a \bmod \mathsf{Z}_A \ne 0 \vee \mathbf{j}_{(\nicefrac{a}{\mathsf{Z}_A}) - 1} \not\in \varpi\\
    (\blacktriangleright, \mathbf{j}_{(\nicefrac{a}{\mathsf{Z}_A}) - 1}) &\otherwise
  \end{cases}$$

## A.5 Instruction Tables {#sec:instructiontables}

Note that in the case that the opcode is not defined in the following tables then the instruction is considered invalid, and it results in a panic; $\varepsilon=\panic$.

We assume the skip length $\ell$ is well-defined: $$\ell \equiv \text{skip}(\imath)$$

### A.5.1 Instructions without Arguments {#instructions-without-arguments}

  ------------ -- --- ------------------------
  0               0   $\varepsilon = \panic$
  (lr)1-4 17      0   
  ------------ -- --- ------------------------

### A.5.2 Instructions with Arguments of One Immediate {#instructions-with-arguments-of-one-immediate}

$$\begin{aligned}
  \using l_X = \min(4, \ell) \,,\quad
  \nu_X \equiv \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+1\dots+l_X}))
\end{aligned}$$

  ---- -- --- ------------------------------------
  78      0   $\varepsilon = \host \times \nu_X$
  ---- -- --- ------------------------------------

### A.5.3 Instructions with Arguments of Two Immediates {#instructions-with-arguments-of-two-immediates}

$$\begin{aligned}
    \using l_X &= \min(4, \zeta_{\imath+1} \bmod 8) \,,\quad&
    \nu_X &\equiv \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X})) \\
    \using l_Y &= \min(4, \max(0, \ell - l_X - 1)) \,,\quad&
    \nu_Y &\equiv \mathcal{X}_{l_Y}(\de_{l_Y}(\zeta_{\imath+2+l_X\dots+l_Y}))
\end{aligned}$$

  ------------ -- --- ------------------------------------------------------------------------
  62              0   ${{\mu}'}^\circlearrowleft_{\nu_X} = \nu_Y \bmod 2^8$
  (lr)1-4 79      0   ${{\mu}'}^\circlearrowleft_{\nu_X\dots+2} = \se_2(\nu_Y \bmod 2^{16})$
  (lr)1-4 38      0   ${{\mu}'}^\circlearrowleft_{\nu_X\dots+4} = \se_4(\nu_Y)$
  ------------ -- --- ------------------------------------------------------------------------

### A.5.4 Instructions with Arguments of One Offset {#instructions-with-arguments-of-one-offset}

$$\begin{aligned}
  \using l_X = \min(4, \ell) \,,\quad
  \nu_X \equiv \imath + \mathcal{Z}_{l_X}(\de_{l_X}(\zeta_{\imath+1\dots+l_X}))
\end{aligned}$$

  --- -- --- -------------------------------
  5      0   $\token{branch}(\nu_X, \top)$
  --- -- --- -------------------------------

### A.5.5 Instructions with Arguments of One Register & One Immediate {#instructions-with-arguments-of-one-register-one-immediate}

$$\begin{aligned}
    \using r_A &= \min(12, \zeta_{\imath+1} \bmod 16) \,,\quad&
    {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
    {\omega}'_A \equiv {\omega}'_{r_A} \\
    \using l_X &= \min(4, \max(0, \ell - 1)) \,,\quad&
    \nu_X &\equiv \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X}))
\end{aligned}$$

  ------------ -- --- --------------------------------------------------------------------------------------------------------
  19              0   $\token{djump}(({\omega}_A + \nu_X) \bmod 2^{32})$
  (lr)1-4 4       0   ${\omega}'_A = \nu_X$
  (lr)1-4 60      0   ${\omega}'_A = {\mu}_{\nu_X}$
  (lr)1-4 74      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\mathcal{Z}_{1}({\mu}_{\nu_X}))$
  (lr)1-4 76      0   ${\omega}'_A = \de_2({\mu}^{\circlearrowleft}_{\nu_X\dots+2})$
  (lr)1-4 66      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\mathcal{Z}_{2}(\de_2({\mu}^{\circlearrowleft}_{\nu_X\dots+2})))$
  (lr)1-4 10      0   ${\omega}'_A = \de_4({\mu}^{\circlearrowleft}_{\nu_X\dots+4})$
  (lr)1-4 71      0   ${{\mu}'}^{\circlearrowleft}_{\nu_X} = {\omega}_A \bmod 2^8$
  (lr)1-4 69      0   ${{\mu}'}^{\circlearrowleft}_{\nu_X\dots+2} = \se_2({\omega}_A \bmod 2^{16})$
  (lr)1-4 22      0   ${{\mu}'}^{\circlearrowleft}_{\nu_X\dots+4} = \se_4({\omega}_A)$
  ------------ -- --- --------------------------------------------------------------------------------------------------------

### A.5.6 Instructions with Arguments of One Register & Two Immediates {#instructions-with-arguments-of-one-register-two-immediates}

$$\begin{aligned}
    \using r_A &= \min(12, \zeta_{\imath+1} \bmod 16) \,,\quad&
    {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
    {\omega}'_A \equiv {\omega}'_{r_A} \\
    \using l_X &= \min(4, \ffrac{\zeta_{\imath+1}}{16} \bmod 8) \,,\quad&
    \nu_X &= \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X})) \\
    \using l_Y &= \min(4, \max(0, \ell - l_X - 1)) \,,\quad&
    \nu_Y &= \mathcal{X}_{l_Y}(\de_{l_Y}(\zeta_{\imath+2+l_X\dots+l_Y}))
\end{aligned}$$

  ------------ -- --- -----------------------------------------------------------------------------------------
  26              0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_A + \nu_X} = \nu_Y \bmod 2^8$
  (lr)1-4 54      0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_A + \nu_X \dots+ 2} = \se_2(\nu_Y \bmod 2^{16})$
  (lr)1-4 13      0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_A + \nu_X \dots+ 4} = \se_4(\nu_Y)$
  ------------ -- --- -----------------------------------------------------------------------------------------

### A.5.7 Instructions with Arguments of One Register, One Immediate and One Offset {#instructions-with-arguments-of-one-register-one-immediate-and-one-offset}

$$\begin{aligned}
      \using r_A &= \min(12, \zeta_{\imath+1} \bmod 16) \,,\quad&
      {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
      {\omega}'_A \equiv {\omega}'_{r_A} \\
      \using l_X &= \min(4, \ffrac{\zeta_{\imath+1}}{16} \bmod 8) \,,\quad&
      \nu_X &= \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X})) \\
      \using l_Y &= \min(4, \max(0, \ell - l_X - 1)) \,,\quad&
      \nu_Y &= \imath + \mathcal{Z}_{l_Y}(\de_{l_Y}(\zeta_{\imath+2+l_X\dots+l_Y}))
  \end{aligned}$$

  ------------ -- --- ---------------------------------------------------------------------------------
  6               0   $\token{branch}(\nu_Y, \top)\ ,\qquad {\omega}_A' = \nu_X$
  (lr)1-4 7       0   $\token{branch}(\nu_Y, {\omega}_A = \nu_X)$
  (lr)1-4 15      0   $\token{branch}(\nu_Y, {\omega}_A \ne \nu_X)$
  (lr)1-4 44      0   $\token{branch}(\nu_Y, {\omega}_A < \nu_X)$
  (lr)1-4 59      0   $\token{branch}(\nu_Y, {\omega}_A \le \nu_X)$
  (lr)1-4 52      0   $\token{branch}(\nu_Y, {\omega}_A \ge \nu_X)$
  (lr)1-4 50      0   $\token{branch}(\nu_Y, {\omega}_A > \nu_X)$
  (lr)1-4 32      0   $\token{branch}(\nu_Y, \mathcal{Z}_{4}({\omega}_A) < \mathcal{Z}_{4}(\nu_X))$
  (lr)1-4 46      0   $\token{branch}(\nu_Y, \mathcal{Z}_{4}({\omega}_A) \le \mathcal{Z}_{4}(\nu_X))$
  (lr)1-4 45      0   $\token{branch}(\nu_Y, \mathcal{Z}_{4}({\omega}_A) \ge \mathcal{Z}_{4}(\nu_X))$
  (lr)1-4 53      0   $\token{branch}(\nu_Y, \mathcal{Z}_{4}({\omega}_A) > \mathcal{Z}_{4}(\nu_X))$
  ------------ -- --- ---------------------------------------------------------------------------------

### A.5.8 Instructions with Arguments of Two Registers {#instructions-with-arguments-of-two-registers}

$$\begin{aligned}
  \using r_D &= \min(12, (\zeta_{\imath+1}) \bmod 16) \,,\quad&
  {\omega}_D &\equiv {\omega}_{r_D} \,,\quad
  {\omega}'_D \equiv {\omega}'_{r_D} \\
  \using r_A &= \min(12, \ffrac{\zeta_{\imath+1}}{16}) \,,\quad&
  {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
  {\omega}'_A \equiv {\omega}'_{r_A} \\
\end{aligned}$$

  ------------ -- --- --------------------------------------------------------
  82              0   ${\omega}'_D = {\omega}_A$
  (lr)1-4 87      0   $\begin{aligned}
                          {\omega}'_D \equiv &\min(x \in \N_R): \\
                          &x \ge h\\
                          &\N_{x\dots+{\omega}_A} \not\in \mathbb{V}_{\mu}\\
                          &\N_{x\dots+{\omega}_A} \in \mathbb{V}^*_{\mu'}
                        \end{aligned}$
  ------------ -- --- --------------------------------------------------------

Note, the term $h$ above refers to the beginning of the heap, the second major segment of memory as defined in equation [\[eq:memlayout\]](#eq:memlayout){reference-type="ref" reference="eq:memlayout"} as $2\mathsf{Z}_Q + Q(|\mathbf{o}|)$. If $\token{sbrk}$ instruction is invoked on a [pvm]{.smallcaps} instance which does not have such a memory layout, then $h = 0$.

### A.5.9 Instructions with Arguments of Two Registers & One Immediate {#instructions-with-arguments-of-two-registers-one-immediate}

$$\begin{aligned}
  \using r_A &= \min(12, (\zeta_{\imath+1}) \bmod 16) \,,\quad&
  {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
  {\omega}'_A \equiv {\omega}'_{r_A} \\
  \using r_B &= \min(12, \ffrac{\zeta_{\imath+1}}{16}) \,,\quad&
  {\omega}_B &\equiv {\omega}_{r_B} \,,\quad
  {\omega}'_B \equiv {\omega}'_{r_B} \\
  \using l_X &= \min(4, \max(0, \ell - 1)) \,,\quad&
  \nu_X &\equiv \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X}))
\end{aligned}$$

  ------------ -- --- --------------------------------------------------------------------------------------------------------------------------
  16              0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_B + \nu_X} = {\omega}_A \bmod 2^8$
  (lr)1-4 29      0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_B + \nu_X \dots+ 2} = \se_2({\omega}_A \bmod 2^{16})$
  (lr)1-4 3       0   ${{\mu}'}^{\circlearrowleft}_{{\omega}_B + \nu_X \dots+ 4} = \se_4({\omega}_A)$
  (lr)1-4 11      0   ${\omega}'_A = {\mu}_{{\omega}_B + \nu_X}$
  (lr)1-4 21      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\mathcal{Z}_{1}({\mu}_{{\omega}_B + \nu_X}))$
  (lr)1-4 37      0   ${\omega}'_A = \de_2({\mu}^{\circlearrowleft}_{{\omega}_B + \nu_X\dots+2})$
  (lr)1-4 33      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\mathcal{Z}_{2}(\de_2({\mu}^{\circlearrowleft}_{{\omega}_B + \nu_X\dots+2})))$
  (lr)1-4 1       0   ${\omega}'_A = \de_4({\mu}^{\circlearrowleft}_{{\omega}_B + \nu_X\dots+4})$
  (lr)1-4 2       0   ${\omega}'_A = ({\omega}_B + \nu_X) \bmod 2^{32}$
  (lr)1-4 18      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_A)_i = \mathcal{B}_{4}({\omega}_B)_i \wedge \mathcal{B}_{4}(\nu_X)_i$
  (lr)1-4 31      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_A)_i = \mathcal{B}_{4}({\omega}_B)_i \oplus \mathcal{B}_{4}(\nu_X)_i$
  (lr)1-4 49      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_A)_i = \mathcal{B}_{4}({\omega}_B)_i \vee \mathcal{B}_{4}(\nu_X)_i$
  (lr)1-4 35      0   ${\omega}'_A = ({\omega}_B \cdot \nu_X) \bmod 2^{32}$
  (lr)1-4 65      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\floor{(\mathcal{Z}_{4}({\omega}_B) \cdot \mathcal{Z}_{4}(\nu_X)) \div 2^{32}})$
  (lr)1-4 63      0   ${\omega}'_A = \floor{({\omega}_B \cdot \nu_X) \div 2^{32}}$
  (lr)1-4 27      0   ${\omega}'_A = {\omega}_B < \nu_X$
  (lr)1-4 56      0   ${\omega}'_A = \mathcal{Z}_{4}({\omega}_B) < \mathcal{Z}_{4}(\nu_X)$
  (lr)1-4 9       0   ${\omega}'_A = ({\omega}_B \cdot 2^{\nu_X \bmod 32}) \bmod 2^{32}$
  (lr)1-4 14      0   ${\omega}'_A = \floor{{\omega}_B \div 2^{\nu_X \bmod 32}}$
  (lr)1-4 25      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\floor{\mathcal{Z}_{4}({\omega}_B) \div 2^{\nu_X \bmod 32}})$
  (lr)1-4 40      0   ${\omega}'_A = (\nu_X + 2^{32} - {\omega}_B) \bmod 2^{32}$
  (lr)1-4 39      0   ${\omega}'_A = {\omega}_B > \nu_X$
  (lr)1-4 61      0   ${\omega}'_A = \mathcal{Z}_{4}({\omega}_B) > \mathcal{Z}_{4}(\nu_X)$
  (lr)1-4 75      0   ${\omega}'_A = (\nu_X \cdot 2^{{\omega}_B \bmod 32}) \bmod 2^{32}$
  (lr)1-4 72      0   ${\omega}'_A = \floor{\nu_X \div 2^{{\omega}_B \bmod 32}}$
  (lr)1-4 80      0   ${\omega}'_A = \mathcal{Z}_{4}^{-1} (\floor{\mathcal{Z}_{4}(\nu_X) \div 2^{{\omega}_B \bmod 32}})$
  (lr)1-4 85      0   ${\omega}'_A = \begin{cases}
                          \nu_X &\when {\omega}_B = 0\\
                          {\omega}_A &\otherwise
                        \end{cases}$
  (lr)1-4 86      0   ${\omega}'_A = \begin{cases}
                          \nu_X &\when {\omega}_B \ne 0\\
                          {\omega}_A &\otherwise
                        \end{cases}$
  ------------ -- --- --------------------------------------------------------------------------------------------------------------------------

### A.5.10 Instructions with Arguments of Two Registers & One Offset {#instructions-with-arguments-of-two-registers-one-offset}

$$\begin{aligned}
    \using r_A &= \min(12, (\zeta_{\imath+1}) \bmod 16) \,,\quad&
    {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
    {\omega}'_A \equiv {\omega}'_{r_A} \\
    \using r_B &= \min(12, \ffrac{\zeta_{\imath+1}}{16}) \,,\quad&
    {\omega}_B &\equiv {\omega}_{r_B} \,,\quad
    {\omega}'_B \equiv {\omega}'_{r_B} \\
    \using l_X &= \min(4, \max(0, \ell - 1)) \,,\quad&
    \nu_X &\equiv \imath + \mathcal{Z}_{l_X}(\de_{l_X}(\zeta_{\imath+2\dots+l_X}))
  \end{aligned}$$

  ------------ -- --- --------------------------------------------------------------------------------------
  24              0   $\token{branch}(\nu_X, {\omega}_A = {\omega}_B)$
  (lr)1-4 30      0   $\token{branch}(\nu_X, {\omega}_A \ne {\omega}_B)$
  (lr)1-4 47      0   $\token{branch}(\nu_X, {\omega}_A < {\omega}_B)$
  (lr)1-4 48      0   $\token{branch}(\nu_X, \mathcal{Z}_{4}({\omega}_A) < \mathcal{Z}_{4}({\omega}_B))$
  (lr)1-4 41      0   $\token{branch}(\nu_X, {\omega}_A \ge {\omega}_B)$
  (lr)1-4 43      0   $\token{branch}(\nu_X, \mathcal{Z}_{4}({\omega}_A) \ge \mathcal{Z}_{4}({\omega}_B))$
  ------------ -- --- --------------------------------------------------------------------------------------

### A.5.11 Instruction with Arguments of Two Registers and Two Immediates {#instruction-with-arguments-of-two-registers-and-two-immediates}

$$\begin{aligned}
    \using r_A &= \min(12, (\zeta_{\imath+1}) \bmod 16) \,,\quad&
    {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
    {\omega}'_A \equiv {\omega}'_{r_A} \\
    \using r_B &= \min(12, \ffrac{\zeta_{\imath+1}}{16}) \,,\quad&
    {\omega}_B &\equiv {\omega}_{r_B} \,,\quad
    {\omega}'_B \equiv {\omega}'_{r_B} \\
    \using l_X &= \min(4, \zeta_{\imath+2} \bmod 8) \,,\quad&
    \nu_X &= \mathcal{X}_{l_X}(\de_{l_X}(\zeta_{\imath+3\dots+l_X})) \\
    \using l_Y &= \min(4, \max(0, \ell - l_X - 2)) \,,\quad&
    \nu_Y &= \mathcal{X}_{l_Y}(\de_{l_Y}(\zeta_{\imath+3+l_X\dots+l_Y}))
  \end{aligned}$$

  ---- -- --- -------------------------------------------------------------
  42      0   $\token{djump}(({\omega}_B + \nu_Y) \bmod 2^{32}) \ ,\qquad
                  {\omega}_A' = \nu_X$
  ---- -- --- -------------------------------------------------------------

### A.5.12 Instructions with Arguments of Three Registers {#instructions-with-arguments-of-three-registers}

$$\begin{aligned}
  \using r_A &= \min(12, (\zeta_{\imath+1}) \bmod 16) \,,\quad&
  {\omega}_A &\equiv {\omega}_{r_A} \,,\quad
  {\omega}'_A \equiv {\omega}'_{r_A} \\
  \using r_B &= \min(12, \ffrac{\zeta_{\imath+1}}{16}) \,,\quad&
  {\omega}_B &\equiv {\omega}_{r_B} \,,\quad
  {\omega}'_B \equiv {\omega}'_{r_B} \\
  \using r_D &= \min(12, \zeta_{\imath+2}) \,,\quad&
  {\omega}_D &\equiv {\omega}_{r_D} \,,\quad
  {\omega}'_D \equiv {\omega}'_{r_D} \\
\end{aligned}$$

  ------------ -- --- -------------------------------------------------------------------------------------------------------------------------------
  8               0   ${\omega}'_D = ({\omega}_A + {\omega}_B) \bmod 2^{32}$
  (lr)1-4 20      0   ${\omega}'_D = ({\omega}_A + 2^{32} - {\omega}_B) \bmod 2^{32}$
  (lr)1-4 23      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_D)_i = \mathcal{B}_{4}({\omega}_A)_i \wedge \mathcal{B}_{4}({\omega}_B)_i$
  (lr)1-4 28      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_D)_i = \mathcal{B}_{4}({\omega}_A)_i \oplus \mathcal{B}_{4}({\omega}_B)_i$
  (lr)1-4 12      0   $\forall i \in \N_{32} : \mathcal{B}_{4}({\omega}'_D)_i = \mathcal{B}_{4}({\omega}_A)_i \vee \mathcal{B}_{4}({\omega}_B)_i$
  (lr)1-4 34      0   ${\omega}'_D = ({\omega}_A \cdot {\omega}_B) \bmod 2^{32}$
  (lr)1-4 67      0   ${\omega}'_D = \mathcal{Z}_{4}^{-1} (\floor{(\mathcal{Z}_{4}({\omega}_A) \cdot \mathcal{Z}_{4}({\omega}_B)) \div 2^{32}})$
  (lr)1-4 57      0   ${\omega}'_D = \floor{({\omega}_A \cdot {\omega}_B) \div 2^{32}}$
  (lr)1-4 81      0   ${\omega}'_D = \mathcal{Z}_{4}^{-1} (\floor{(\mathcal{Z}_{4}({\omega}_A) \cdot {\omega}_B) \div 2^{32}})$
  (lr)1-4 68      0   ${\omega}'_D = \begin{cases}
                          2^{32} - 1 &\when {\omega}_B = 0\\
                          \floor{{\omega}_A \div {\omega}_B} &\otherwise
                        \end{cases}$
  (lr)1-4 64      0   ${\omega}'_D = \begin{cases}
                          2^{32} - 1 &\when {\omega}_B = 0\\
                          {\omega}_A &\when \mathcal{Z}_{4}({\omega}_A) = -2^{31} \wedge \mathcal{Z}_{4}({\omega}_B) = -1\\
                          \mathcal{Z}_{4}^{-1} (\floor{\mathcal{Z}_{4}({\omega}_A) \div \mathcal{Z}_{4}({\omega}_B)}) &\otherwise
                        \end{cases}$
  (lr)1-4 73      0   ${\omega}'_D = \begin{cases}
                          {\omega}_A &\when {\omega}_B = 0\\
                          {\omega}_A \bmod {\omega}_B &\otherwise
                        \end{cases}$
  (lr)1-4 70      0   ${\omega}'_D = \begin{cases}
                          {\omega}_A &\when {\omega}_B = 0\\
                          0 &\when \mathcal{Z}_{4}({\omega}_A) = -2^{31} \wedge \mathcal{Z}_{4}({\omega}_B) = -1\\
                          \mathcal{Z}_{4}^{-1} (\mathcal{Z}_{4}({\omega}_A) \bmod \mathcal{Z}_{4}({\omega}_B)) &\otherwise
                        \end{cases}$
  (lr)1-4 36      0   ${\omega}'_D = {\omega}_A < {\omega}_B$
  (lr)1-4 58      0   ${\omega}'_D = \mathcal{Z}_{4}({\omega}_A) < \mathcal{Z}_{4}({\omega}_B)$
  (lr)1-4 55      0   ${\omega}'_D = ({\omega}_A \cdot 2^{{\omega}_B \bmod 32}) \bmod 2^{32}$
  (lr)1-4 51      0   ${\omega}'_D = \floor{{\omega}_A \div 2^{{\omega}_B \bmod 32}}$
  (lr)1-4 77      0   ${\omega}'_D = \mathcal{Z}_{4}^{-1} (\floor{\mathcal{Z}_{4}({\omega}_A) \div 2^{{\omega}_B \bmod 32}})$
  (lr)1-4 83      0   ${\omega}'_D = \begin{cases}
                          {\omega}_A &\when {\omega}_B = 0\\
                          {\omega}_D &\otherwise
                        \end{cases}$
  (lr)1-4 84      0   ${\omega}'_D = \begin{cases}
                          {\omega}_A &\when {\omega}_B \ne 0\\
                          {\omega}_D &\otherwise
                        \end{cases}$
  ------------ -- --- -------------------------------------------------------------------------------------------------------------------------------

## A.6 Host Call Definition {#host-call-definition}

An extended version of the [pvm]{.smallcaps} invocation which is able to progress an inner *host-call* state-machine in the case of a host-call halt condition is defined as $\Psi_H$: $$\Psi_H\colon \left\{\begin{aligned}
    (\Y, \N_R, \N_G, \seq{\N_R}_{13}, \mathbb{M}, \Omega_X, X) &\to (\{\panic, \oog, \halt\} \cup \{\fault\} \times \N_R, \Z_G, \seq{\N_R}_{13}, \mathbb{M}, X)\\
    (\mathbf{c}, \imath, \xi, \omega, {\mu}, f, \mathbf{x}) &\mapsto \begin{cases}
      (\fault \times a, \imath', \xi', \omega', {\mu}', \mathbf{x}) &\when \bigwedge\left\{\;\begin{aligned}
        &\varepsilon = \host \times h\\[2pt]
        &\fault \times a = f(h, \xi', \omega', {\mu}', \mathbf{x})\\[2pt]
      \end{aligned}\right.\\[8 pt]
      \Psi_H(\mathbf{c}, \imath' + 1 + \text{skip}(\imath'), \xi'', \omega'', {\mu}'', f, \mathbf{x}'') &\when \bigwedge\left\{\;\begin{aligned}
        &\varepsilon = \host \times h\\[2pt]
        &(\xi'', \omega'', {\mu}'', \mathbf{x}'') = f(h, \xi', \omega', {\mu}', \mathbf{x})
      \end{aligned}\right.\\[8pt]
      (\varepsilon, \imath', \xi', \omega', {\mu}', \mathbf{x}) &\otherwise
    \end{cases} \\
    \where (\varepsilon, \imath', \xi', \omega', {\mu}') &= \Psi(\mathbf{c}, \imath, \xi, \omega, {\mu})\\
    \end{aligned}\right.$$

On exit, the instruction counter $\imath'$ references the instruction *which caused the exit*. Should the machine be invoked again using this instruction counter and code, then the same instruction which caused the exit would be executed. This is sensible when the instruction is one which necessarily needs re-executing such as in the case of an out-of-gas or page fault reason.

However, when the exit reason to $\Psi$ is a host-call $\host$, then the resultant instruction-counter has a value of the host-call instruction and resuming with this state would immediately exit with the same result. Re-invoking would therefore require both the post-host-call machine state *and* the instruction counter value for the instruction following the one which resulted in the host-call exit reason. This is always one greater plus the relevant argument skip distance. Resuming the machine with this instruction counter will continue beyond the host-call instruction.

We use both values of instruction-counter for the definition of $\Psi_H$ since if the host-call results in a page fault we need to allow the outer environment to resolve the fault and re-try the host-call. Conversely, if we successfully transition state according to the host-call, then on resumption we wish to begin with the instruction directly following the host-call.

## A.7 Standard Program Initialization {#sec:standardprograminit}

The software programs which will run in each of the four instances where the [pvm]{.smallcaps} is utilized in the main document have a very typical setup pattern characteristic of an output of a compiler and linker. This means sections for program-specific read-only data, read-write (heap) data and the stack. An adjunct to this, very typical of our usage patterns is an extra read-only segment via which invocation-specific data may be passed (i.e. arguments). It thus makes sense to define this properly in a single initializer function.

We thus define the standard program code format $\mathbf{p}$, which includes not only the instructions and jump table (previously represented by the term $\mathbf{c}$), but also information on the state of the [ram]{.smallcaps} and registers at program start. Given some $\mathbf{p}$ which is appropriately encoded together with some argument data $\mathbf{a}$, we can define program code $\mathbf{c}$, registers $\omega$ and [ram]{.smallcaps} ${\mu}$ through the standard initialization decoder function $Y$: $$Y\colon\left\{\begin{aligned}
  \Y &\to (\Y, \seq{\N_R}_{13}, \mathbb{M})? \\
  \mathbf{p} &\mapsto x
\end{aligned}\right.$$ Where: $$\begin{aligned}
  &\using \mathcal{E}_3(|\mathbf{o}|) \concat \mathcal{E}_3(|\mathbf{w}|) \concat \mathcal{E}_2(z) \concat \mathcal{E}_3(s) \concat \mathbf{o} \concat \mathbf{w} \concat \mathcal{E}_4(|\mathbf{c}|) \concat \mathbf{c} = \mathbf{p}\\
  &\mathsf{Z}_P = 2^{14}\ ,\quad\mathsf{Z}_Q = 2^{16}\ ,\quad\mathsf{Z}_I = 2^{24}\\
  &\using P(x \in \N) \equiv \mathsf{Z}_P\left\lceil \frac{x}{\mathsf{Z}_P} \right\rceil\quad,\qquad Q(x \in \N) \equiv \mathsf{Z}_Q\left\lceil \frac{x}{\mathsf{Z}_Q} \right\rceil\\
  &5\mathsf{Z}_Q + Q(|\mathbf{o}|) + Q(|\mathbf{w}| + z\mathsf{Z}_P) + Q(s) + \mathsf{Z}_I \leq 2^{32}\end{aligned}$$ If the above cannot be satisfied, then $x = \none$, otherwise $x = (\mathbf{c}, \omega, {\mu})$ with $\mathbf{c}$ as above and ${\mu}$, $\omega$ such that: $$\label{eq:memlayout}
  \forall i \in \N_R : {\mu}_i = \left\{\begin{alignedat}{5}
    &\tup{\is{\mathbf{V}}{\mathbf{o}_{i - \mathsf{Z}_Q}}\ts\is{\mathbf{A}}{R}} &&\ \when
        \mathsf{Z}_Q
            &\ \leq i < \ &&
                \mathsf{Z}_Q + |\mathbf{o}|\\
    &(0, R) &&\ \when
        \mathsf{Z}_Q + |\mathbf{o}|
            &\ \leq i < \ &&
                \mathsf{Z}_Q + P(|\mathbf{o}|) \\
    &(\mathbf{w}_{i - (2\mathsf{Z}_Q + Q(|\mathbf{o}|))}, W) &&\ \when
        2\mathsf{Z}_Q + Q(|\mathbf{o}|)
            &\ \leq i < \ &&
                2\mathsf{Z}_Q + Q(|\mathbf{o}|) + |\mathbf{w}|\\
    &(0, W) &&\ \when
        2\mathsf{Z}_Q + Q(|\mathbf{o}|) + |\mathbf{w}|
            &\ \leq i < \ &&
                2\mathsf{Z}_Q + Q(|\mathbf{o}|) + P(|\mathbf{w}|) + z\mathsf{Z}_P\\
    &(0, W) &&\ \when
        2^{32} - 2\mathsf{Z}_Q - \mathsf{Z}_I - P(s)
            &\ \leq i < \ &&
                2^{32} - 2\mathsf{Z}_Q - \mathsf{Z}_I\\
    &(\mathbf{a}_{i - (2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I)}, R) &&\ \when
        2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I
            &\ \leq i < \ &&
                2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I + |\mathbf{a}|\\
    &(0, R) &&\ \when
        2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I + |\mathbf{a}|
            &\ \leq i < \ &&
                2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I + P(|\mathbf{a}|)\\
    &(0, \none) &&\otherwise&&&
  \end{alignedat}\right.\\$$ $$\forall i \in \N_{16} : \omega_i = \begin{cases}
      2^{32} - 2^{16} &\when i = 1\\
      2^{32} - 2\mathsf{Z}_Q - \mathsf{Z}_I &\when i = 2\\
      2^{32} - \mathsf{Z}_Q - \mathsf{Z}_I &\when i = 10\\
      |\mathbf{a}|&\when i = 11\\
      0 &\otherwise
    \end{cases}$$

## A.8 Argument Invocation Definition {#argument-invocation-definition}

The four instances where the [pvm]{.smallcaps} is utilized each expect to be able to pass argument data in and receive some return data back. We thus define the common [pvm]{.smallcaps} program-argument invocation function $\Psi_M$: $$\begin{aligned}
  \Psi_M&\colon \left\{\begin{aligned}
    (\Y, \N, \N_G, \Y_{:\mathsf{Z}_I}, \Omega_X, X) &\to ((\N_G, \Y) \cup \{\panic, \oog\}, X)\\
    (\mathbf{p}, \imath, \xi, \mathbf{a}, f, \mathbf{x}) &\mapsto \begin{cases}
      (\panic, \mathbf{x}) &\when Y(\mathbf{p}) = \none\\
      R(\Psi_H(\mathbf{c}, \imath, \xi, \omega, {\mu}, f, \mathbf{x})) &\when Y(\mathbf{p}) = (\mathbf{c}, \omega, {\mu})
    \end{cases}
  \end{aligned}\right.\\
  \where R&\colon (\varepsilon, \imath', \xi', \omega', {\mu}', \mathbf{x}) \mapsto \begin{cases}
    (\oog, \mathbf{x}) &\when \varepsilon = \oog \\
    ((\xi', \mu'_{\omega'_{10}\dots+\omega'_{11}}), \mathbf{x}) &\when \varepsilon = \halt \wedge \mathbb{Z}_{\omega'_{10}\dots+\omega'_{11}} \subset \mathbb{V}_{{\mu}'} \\
    ((\xi', []), \mathbf{x}) &\when \varepsilon = \halt \wedge \mathbb{Z}_{\omega'_{10}\dots+\omega'_{11}} \not\subset \mathbb{V}_{{\mu}'} \\
    (\panic, \mathbf{x}) &\otherwise \\
  \end{cases}\end{aligned}$$

# B Virtual Machine Invocations {#sec:virtualmachineinvocations}

## B.1 Host-Call Result Constants {#host-call-result-constants}

$\mathtt{NONE} = 2^{32} - 1$

:   The return value indicating an item does not exist.

$\mathtt{WHAT} = 2^{32} - 2$

:   Name unknown.

$\mathtt{OOB} = 2^{32} - 3$

:   The return value for when a memory index is provided for reading/writing which is not accessible.

$\mathtt{WHO} = 2^{32} - 4$

:   Index unknown.

$\mathtt{FULL} = 2^{32} - 5$

:   Storage full.

$\mathtt{CORE} = 2^{32} - 6$

:   Core index unknown.

$\mathtt{CASH} = 2^{32} - 7$

:   Insufficient funds.

$\mathtt{LOW} = 2^{32} - 8$

:   Gas limit too low.

$\mathtt{HIGH} = 2^{32} - 9$

:   Gas limit too high.

$\mathtt{HUH} = 2^{32} - 10$

:   The item is already solicited or cannot be forgotten.

$\mathtt{OK} = 0$

:   The return value indicating general success.

Inner [pvm]{.smallcaps} invocations have their own set of result codes:

$\mathtt{HALT} = 0$

:   The invocation completed and halted normally.

$\mathtt{PANIC} = 1$

:   The invocation completed with a panic.

$\mathtt{FAULT} = 2$

:   The invocation completed with a page fault.

$\mathtt{HOST} = 3$

:   The invocation completed with a host-call fault.

Note return codes for a host-call-request exit are any non-zero value less than $2^{32} - 13$.

## B.2 Is-Authorized Invocation {#sec:isauthorizedinvocation}

The Is-Authorized invocation is the first and simplest of the four, being totally stateless. It provides only a single host-call function, $\Omega_G$ for determining the amount of gas remaining. It accepts as arguments the work-package as a whole, $\mathbf{p}$ and the core on which it should be executed, $c$. Formally, it is defined as $\Psi_I$:

$$\begin{aligned}
  \Psi_I &\colon \left\{\begin{aligned}
    (\mathbb{P}, \N_\mathsf{C}) &\to \Y \cup \mathbb{J} \\
    (\mathbf{p}, c) &\mapsto \begin{cases}
      \mathbf{r} &\otherwhen \mathbf{r} \in \{ \oog, \panic \}  \\
      \mathbf{o} &\otherwhen \mathbf{r} = \tup{g, \mathbf{o}} \\
      \multicolumn{2}{l}{\quad\where (\mathbf{r}, \none) = \Psi_M(\mathbf{p}_\mathbf{c}, 0, \mathsf{G}_I, \mathcal{E}(\mathbf{p}, c), F, \none)}
    \end{cases} \\
  \end{aligned}\right. \\
  \label{eq:isauthorizedmutator}F&\colon\left\{\begin{aligned}
    (\N, \N_G, \lseq\N_R\rseq_6, \mathbb{M}) &\to (\Z_G, \lseq\N_R\rseq_2, \mathbb{M})\\
    (n, \xi, \omega, \mu) &\mapsto \begin{cases}
      \Omega_G(\xi, \omega, \mu) &\when n = \mathtt{gas} \\
      (\xi - 10, [\mathtt{WHAT}, \omega_1, \dots], \mu) &\otherwise
    \end{cases}
  \end{aligned}
  \right.\end{aligned}$$ Note for the Is-Authorized host-call dispatch function $F$ in equation [\[eq:isauthorizedmutator\]](#eq:isauthorizedmutator){reference-type="ref" reference="eq:isauthorizedmutator"}, we elide the host-call context since, being essentially stateless, it is always $\none$.

## B.3 Refine Invocation {#sec:refineinvocation}

We define the Refine service-account invocation function as $\Psi_R$. It has no general access to the state of the JAM chain, with the slight exception being the ability to make a historical lookup. Beyond this it is able to create inner instances of the [pvm]{.smallcaps} and dictate pieces of data to export.

The historical-lookup host-call function, $\Omega_H$, is designed to give the same result regardless of the state of the chain for any time when auditing may occur (which we bound to be less than two epochs from being accumulated). The lookup anchor may be up to $\mathsf{L}$ timeslots before the recent history and therefore adds to the potential age at the time of audit. We therefore set $\mathsf{D} = 4,800$, a safe amount of eight hours.

The inner [pvm]{.smallcaps} invocation host-calls, meanwhile, depend on an integrated [pvm]{.smallcaps} type, which we shall denote $\mathbf{M}$. It holds some program code, instruction counter and [ram]{.smallcaps}: $$\mathbf{M}\equiv \tuple{\isa{\mathbf{p}}{\Y}, \isa{\mathbf{u}}{\mathbb{M}}, \isa{i}{\N_R}}$$

The Export host-call depends on two pieces of context; one sequence of segments (blobs of length $\mathsf{W}_S$) to which it may append, and the other an argument passed to the invocation function to dictate the number of segments prior which may assumed to have already been appended. The latter value ensures that an accurate segment index can be provided to the caller.

The Refine invocation function also implicitly draws upon some recent head state $\delta$ and explicitly accepts the work payload, $\mathbf{y}$, together with the service index which is the subject of refinement $s$, the prediction of the hash of that service's code $c$ at the time of reporting, the hash of the containing work-package $p$, the refinement context $\mathbf{c}$, the authorizer hash $a$ and its output $\mathbf{o}$, and an export segment offset $\varsigma$, the import segments and extrinsic data blobs as dictated by the work-item, $\mathbf{i}$ and $\overline{\mathbf{x}}$. It results in either some error $\mathbb{J}$ or a pair of the refinement output blob and the export sequence. Formally: $$\begin{aligned}
  \Psi_R &\colon \left\{\begin{aligned}
    \left(\begin{aligned}
      &\H, \N_G, \N_S, \H, \Y, \mathbb{X},\\
      &\H, \Y, \seq{\G}, \seq{\Y}, \N
    \end{aligned}
    \right) &\to (\Y \cup \mathbb{J}, \seq{\Y}) \\
    (c, g, s, p, \mathbf{y}, \mathbf{c}, a, \mathbf{o}, \mathbf{i}, \overline{\mathbf{x}}, \varsigma) &\mapsto \begin{cases}
      (\token{BAD}, []) &\when s \not\in \keys{\delta} \vee \Lambda(\delta[s], \mathbf{c}_t, c) = \none \\
      (\token{BIG}, []) &\otherwhen |\Lambda(\delta[s], \mathbf{c}_t, c)| > \mathsf{S} \\
      &\otherwise: \\
      &\quad\using a = \se(s, \mathbf{y}, p, \mathbf{c}, a, \mathbf{o}, \var{\sq{\var{\mathbf{x}} \mid \mathbf{x} \orderedin \overline{\mathbf{x}}}})\ ,\\
      &\quad\also (\mathbf{r}, (\mathbf{m}, \mathbf{e})) = \Psi_M(\Lambda(\delta[s], \mathbf{c}_t, c), 5, g, a, F, (\emptyset, []))\ \colon\\
      (\mathbf{r}, []) &\quad\when \mathbf{r} \in \{ \oog, \panic \}  \\
      (\mathbf{u}, \mathbf{e}) &\quad\when \mathbf{r} = \tup{g, \mathbf{u}} \\
    \end{cases} \\
  \end{aligned}\right. \\
  \label{eq:refinemutator}
  F&\colon\left\{\begin{aligned}
    (\N, \N_G, \seq{\N_R}_6, \mathbb{M}, (\dict{\N}{\mathbf{M}}, \seq{\Y})) &\to (\N_G, \seq{\N_R}_2, \mathbb{M}, (\dict{\N}{\mathbf{M}}, \seq{\Y}))\\
    (n, \xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\mapsto \begin{cases}
      \Omega_H(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e}), s, \delta, \mathbf{c}_t) &\when n = \mathtt{historical\_lookup}\\
      \Omega_Y(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e}), \mathbf{i}) &\when n = \mathtt{import}\\
      \Omega_Z(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e}), \varsigma) &\when n = \mathtt{export}\\
      \Omega_G(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{gas}\\
      \Omega_M(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{machine}\\
      \Omega_P(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{peek}\\
      \Omega_O(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{poke}\\
      \Omega_K(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{invoke}\\
      \Omega_X(\xi, \omega, \mu, (\mathbf{m}, \mathbf{e})) &\when n = \mathtt{expunge}\\
      (\xi - 10, [\mathtt{WHAT}, \omega_1, \dots], \mu) &\otherwise
    \end{cases}
  \end{aligned}
  \right.\end{aligned}$$

## B.4 Accumulate Invocation {#sec:accumulateinvocation}

Since this is a transition which can directly affect a substantial amount of on-chain state, our invocation context is accordingly complex. It is a tuple with elements for each of the aspects of state which can be altered through this invocation and beyond the account of the service itself includes the deferred transfer list and several dictionaries for alterations to preimage lookup state, core assignments, validator key assignments, newly created accounts and alterations to account privilege levels.

Formally, we define our result context to be $\mathbf{X}$, and our invocation context to be a pair of these contexts, $\mathbf{X} \times \mathbf{X}$, with one dimension being the regular dimension and generally named $\mathbf{x}$ and the other being the exceptional dimension and being named $\mathbf{y}$. The only function which actually alters this second dimension is $\mathtt{checkpoint}$, $\Omega_C$ and so it is rarely seen.

We track both regular and exceptional dimensions within our context mutator, but collapse the result of the invocation to one or the other depending on whether the termination was regular or exceptional (i.e. out-of-gas or panic). $$\mathbf{X} \equiv \ltuple\begin{array}{lll}
    \isa{\mathbf{s}}{\mathbb{A}\bm{?}}\ts&
    \isa{\mathbf{c}}{\seq{\seq{\H}_\mathsf{Q}}_\mathsf{C}}\ts&
    \isa{\mathbf{v}}{\seq{\mathbb{K}}_\mathsf{V}}\ts\quad
    \isa{i}{\N_S}\ts\\
    \isa{\mathbf{t}}{\seq{\mathbb{T}}}\ts&
    \isa{\mathbf{n}}{\dict{\N_S}{\mathbb{A}}}\ts&
    \isa{p}{\tuple{\isa{m}{\N_S}\ts\isa{a}{\N_S}\ts\isa{v}{\N_S}}}
  \end{array}\rtuple$$

We define $\Psi_A$, the Accumulation invocation function as: $$\begin{aligned}
  \Psi_A &:
  \begin{cases}
    \left(
        \dict{\N_S}{\mathbb{A}},\N_S,\N_G,\lseq\mathbb{O}\rseq
    \right)
    &\to
    \mathbf{X} \times \tuple{\isa{r}{\H?}}\\
    (\delta^\dagger, s, g, \mathbf{o}) &\mapsto \begin{cases}
      \tup{
        \is{\mathbf{s}}{\delta^\dagger[s]} \ts
        \is{\mathbf{t}}{[]} \ts
        \is{p}{\chi} \ts
        \is{\mathbf{c}}{\varphi} \ts
        \is{\mathbf{v}}{\iota} \ts
        \is{\mathbf{n}}{\emptyset} \ts
        \is{r}{\none}
      } &\when \delta^\dagger[s]_\mathbf{c} = \none \\
      C(\Psi_M(\delta^\dagger[s]_\mathbf{c}, 10, g, \mathcal{E}(\var{\mathbf{o}}), F, I(\delta^\dagger[s], s))) &\otherwise
    \end{cases} \\
  \end{cases}\end{aligned}$$ $$\begin{aligned}
  I(\mathbf{a} \in \mathbb{A}, s \in \N_S) &\equiv (\mathbf{x}, \mathbf{y}) \text{ where }
  \left\{ \begin{aligned}
    \mathbf{x} &= \mathbf{y} = \tup{\is{\mathbf{s}}{\mathbf{a}}\ts\is{\mathbf{t}}{[]}\ts i\ts\is{p}{\chi}\ts\is{\mathbf{c}}{\varphi}\ts\is{\mathbf{v}}{\iota}\ts\is{\mathbf{n}}{\emptyset}}\ ,\\
    i &= \text{check}((\de_4(\mathcal{H}(s, \eta'_0, \mathbf{H}_t)) \bmod (2^{32}-2^9)) + 2^8)
  \end{aligned} \right. \\
  F(n, \xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\equiv \begin{cases}
    G(\Omega_R(\xi, \omega, \mu, \mathbf{x}_\mathbf{s}, s, \delta^\dagger), (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{read} \\
    G(\Omega_W(\xi, \omega, \mu, \mathbf{x}_\mathbf{s}), (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{write} \\
    G(\Omega_L(\xi, \omega, \mu, \mathbf{x}_\mathbf{s}, s, \delta^\dagger), (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{lookup} \\
    G(\Omega_G(\xi, \omega, \mu), (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{gas} \\
    G(\Omega_I(\xi, \omega, \mu, \mathbf{x}_\mathbf{s}, s, \delta^\dagger), (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{info} \\
    \Omega_E(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{empower}\\
    \Omega_A(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{assign}\\
    \Omega_D(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{designate}\\
    \Omega_C(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{checkpoint} \\
    \Omega_N(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y})) &\when n = \mathtt{new} \\
    \Omega_U(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y}), s) &\when n = \mathtt{upgrade} \\
    \Omega_T(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y}), s, \delta^\dagger) &\when n = \mathtt{transfer} \\
    \Omega_Q(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y}), s) &\when n = \mathtt{quit} \\
    \Omega_S(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y}), \mathbf{H}_t) &\when n = \mathtt{solicit} \\
    \Omega_F(\xi, \omega, \mu, (\mathbf{x}, \mathbf{y}), \mathbf{H}_t) &\when n = \mathtt{forget} \\
    (\xi - 10, [\mathtt{WHAT}, \omega_1, \dots], \mu, \mathbf{x}) &\otherwise
  \end{cases} \\
  G((\xi', \omega', \mu', \mathbf{s}'), (\mathbf{x}, \mathbf{y})) &\equiv (\xi', \omega', \mu', (\mathbf{x}, \mathbf{y}))\ \where \mathbf{x} = \mathbf{x}' \exc \mathbf{x}_\mathbf{s} = \mathbf{s}' \\
  C(\mathbf{o} \in \mathbb{Y} \cup \{\oog, \panic\}, (\mathbf{x}\in\mathbf{X}, \mathbf{y}\in\mathbf{X})) &\equiv \begin{cases}
    \mathbf{x} \times \tup{\is{r}{\mathbf{o}}} & \when \mathbf{o} \in \mathbb{H} \\
    \mathbf{x} \times \tup{\is{r}{\none}} & \when \mathbf{o} \in \mathbb{Y} \setminus \H \\
    \mathbf{y} \times \tup{\is{r}{\none}} & \when \mathbf{o} \in \{\oog, \panic\} \\
  \end{cases}\end{aligned}$$

The mutator $F$ governs how this context will alter for any given parameterization, and the collapse function $C$ selects one of the two dimensions of context depending on whether the virtual machine's halt was regular or exceptional.

The initializer function $I$ maps some service account $\mathbf{s}$ along with its index $s$ to yield a mutator context such that no alterations to state are implied (beyond those already inherent in $\mathbf{s}$) in either exit scenario. Note that the component $a$ utilizes the random accumulator $\eta_0$ and the block's timeslot $\mathbf{H}_t$ to create a deterministic sequence of identifiers which are extremely likely to be unique.

Concretely, we create the identifier from the Blake2 hash of the identifier of the creating service, the current random accumulator $\eta_0$ and the block's timeslot. Thus, within a service's accumulation it is almost certainly unique, but it is not necessarily unique across all services, nor at all times in the past. We utilize a *check* function to find the first such index in this sequence which does not already represent a service: $$\text{check}(i \in \N_S) \equiv \begin{cases}
    i &\when i \not\in \mathcal{K}(\delta^\dagger)\\
    \text{check}((i - 2^8 + 1) \bmod (2^{32}-2^9) + 2^8)&\otherwise
  \end{cases}$$

n.b. In the highly unlikely event that a block executes to find that a single service index has inadvertently been attached to two different services, then the block is considered invalid. Since no service can predict the identifier sequence ahead of time, they cannot intentionally disadvantage the block author.

## B.5 On-Transfer Invocation {#sec:ontransferinvocation}

We define the On-Transfer service-account invocation function as $\Psi_T$; it is somewhat similar to the Accumulation Invocation except that the only state alteration it facilitates are basic alteration to the storage of the subject account. No further transfers may be made, no privileged operations are possible, no new accounts may be created nor other operations done on the subject account itself. The function is defined as: $$\begin{aligned}
  \Psi_T &: \begin{cases}
    (\dict{\N_S}{\mathbb{A}}, \N_S, \seq{\mathbb{T}}) &\to \mathbb{A} \\
    (\delta^\ddagger, s, \mathbf{t}) &\mapsto \begin{cases}
    \mathbf{s} &\when \mathbf{s}_\mathbf{c} = \none \vee \mathbf{t} = [] \\
    \Psi_M(\mathbf{s}_\mathbf{c}, 15, \sum_{r \in \mathbf{t}}{(r_g)}, \mathcal{E}(\mathbf{t}), F, \mathbf{s}) &\otherwise
    \end{cases} \\
  \end{cases} \\
  \where \mathbf{s} &= \delta^\ddagger[s]\exc\mathbf{s}_b = \delta^\ddagger[s]_b + \sum_{r \in \mathbf{t}}{r_a} \\
  F(n, \xi, \omega, \mu, \mathbf{s}) &\equiv \begin{cases}
    \Omega_L(\xi, \omega, \mu, \mathbf{s}, s, \delta^\ddagger) &\when n = \mathtt{lookup} \\
    \Omega_R(\xi, \omega, \mu, \mathbf{s}, s, \delta^\ddagger) &\when n = \mathtt{read} \\
    \Omega_W(\xi, \omega, \mu, \mathbf{s}) &\when n = \mathtt{write} \\
    \Omega_G(\xi, \omega, \mu) &\when n = \mathtt{gas} \\
    \Omega_I(\xi, \omega, \mu, \mathbf{s}, s, \delta^\ddagger) &\when n = \mathtt{info} \\
    (\xi - 10, [\mathtt{WHAT}, \omega_1, \dots], \mu, \mathbf{s}) &\otherwise
  \end{cases}\end{aligned}$$

n.b. When considering the mutator functions $\Omega_R$ and $\Omega_I$, the final arguments passed are both the post-accumulation accounts state, $\delta^\ddagger$. Within the function, this parameter however is denoted simply $\mathbf{d}$. This is intentional and avoids potential confusion since the functions are also utilized for the Accumulation Invocation where the argument is $\delta^\dagger$.

## B.6 General Functions {#sec:generalfunctions}

This defines a number of functions broadly of the form $(\xi' \in \Z_G, \omega' \in \seq{\N_R}_2, \mu', \mathbf{s}') = \Omega_\square(\xi \in \N_G, \omega \in \seq{\N_R}_6, \mu \in \mathbb{M}, \mathbf{s} \in \mathbf{A}, \dots)$. Functions which have a result component which is equivalent to the corresponding argument may have said components elided in the description. Functions may also depend upon particular additional parameters.

Unlike the Accumulate functions in appendix [25.7](#sec:accumulatefunctions){reference-type="ref" reference="sec:accumulatefunctions"}, these do not mutate an accumulation context, but merely a service account $\mathbf{s}$.

The $\mathtt{gas}$ function, $\Omega_G$ has a parameter list suffixed with an ellipsis to denote that any additional parameters may be taken and are provided transparently into its result. This allows it to be easily utilized in multiple [pvm]{.smallcaps} invocations.

$$\begin{aligned}
  \xi' &\equiv \xi - g\\
  (\omega', \mu', \mathbf{s}') &\equiv \begin{cases}
    (\omega, \mu, \mathbf{s}) &\when \xi < g\\
    (\omega, \mu, \mathbf{s}) \text{ except as indicated below} &\otherwise
  \end{cases}\end{aligned}$$

= 1.5mm = 2mm

  ---------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                   
  **Identifier**   
  **Gas usage**    
  (lr)1-1(lr)2-2   
  `gas` = 0        
  $g = 10$         $\begin{aligned}
                       \omega'_0 &\equiv \xi' \bmod 2^{32} \\
                       \omega'_1 &\equiv \left\lfloor \xi' \div 2^{32}\right\rfloor
                     \end{aligned}$
  (lr)1-1(lr)2-2   
  `lookup` = 1     
  $g = 10$         $\begin{aligned}
                       \using \mathbf{a} &= \begin{cases} \mathbf{s} &\when \omega_0 \in \{ s, 2^{32} - 1 \} \\ \mathbf{d}[\omega_0] &\otherwise \end{cases} \\
                       \using [h_o, b_o, b_z] &= \omega_{1..4} \\
                       \using h &= \begin{cases}
                         \mathcal{H}(\mu_{h_o\dots+32}) &\when \mathbb{Z}_{h_o \dots+ 32} \subset \mathbb{V}_{\mu} \\
                         \error &\otherwise
                       \end{cases} \\
                       \using \mathbf{v} &= \begin{cases}
                         \mathbf{a}_\mathbf{p}[h] &\when \mathbf{a} \ne \none \wedge h \in \keys{\mathbf{a}_\mathbf{p}} \\
                         \none &\otherwise
                       \end{cases} \\
                       \forall i \in \N_{\min(b_z, |\mathbf{v}|)} : \mu'_{b_o + i} &\equiv \begin{cases}
                         \mathbf{v}_i & \when \mathbf{v} \ne \none \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                         \mu_{b_o + i} & \otherwise
                       \end{cases} \\
                       \omega'_0 &\equiv \begin{cases}
                         \begin{rcases}
                           \mathtt{NONE} & \when \mathbf{v} = \none \\
                           |\mathbf{v}| &\otherwise \\
                         \end{rcases} &\when h \ne \error \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                         \mathtt{OOB} &\otherwise
                       \end{cases}
                     \end{aligned}$
  (lr)1-1(lr)2-2   
  `read` = 2       
  $g = 10$         $\begin{aligned}
                       \using \mathbf{a} &= \begin{cases}
                         \mathbf{s} &\when \omega_0 \in \{ s, 2^{32} - 1 \} \\
                         \mathbf{d}[\omega_0] &\otherwhen \omega_0 \in \keys{\mathbf{d}} \\
                         \none &\otherwise
                       \end{cases} \\
                       \using [k_o, k_z, b_o, b_z] &= \omega_{1..5} \\
                       \using k &= \begin{cases}
                         \mathcal{H}(\se_4(s) \concat \mu_{k_o\dots+k_z}) &\when \mathbb{Z}_{k_o \dots+ k_z} \subset \mathbb{V}_{\mu} \\
                         \error &\otherwise
                       \end{cases} \\
                       \using \mathbf{v} &= \begin{cases}
                         \mathbf{a}_\mathbf{s}[k] &\when \mathbf{a} \ne \none \wedge k \in \keys{\mathbf{a}_\mathbf{s}} \\
                         \none &\otherwise
                       \end{cases} \\
                       \forall i \in \N_{\min(b_z, |\mathbf{v}|)} : \mu'_{b_o + i} &\equiv \begin{cases}
                         \mathbf{v}_i & \when \mathbf{v} \ne \none \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                         \mu_{b_o + i} & \otherwise
                       \end{cases} \\
                       \omega'_0 &\equiv \begin{cases}
                         \begin{rcases}
                           \mathtt{NONE} & \when \mathbf{v} = \none \\
                           |\mathbf{v}| &\otherwise \\
                         \end{rcases} &\when k \ne \error \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                         \mathtt{OOB} &\otherwise
                       \end{cases}
                     \end{aligned}$
  (lr)1-1(lr)2-2   
  `write` = 3      
  $g = 10$         $\begin{aligned}
                       \using [k_o, k_z, v_o, v_z] &= \omega_{0..4} \\
                       \using k &= \begin{cases}
                         \mathcal{H}(\se_4(s) \concat \mu_{k_o\dots+k_z}) &\when \mathbb{Z}_{k_o \dots+ k_z} \subset \mathbb{V}_{\mu} \\
                         \error &\otherwise
                       \end{cases} \\
                       \using \mathbf{a} &= \begin{cases}
                         \mathbf{s} \exc \begin{rcases}
                           \keys{\mathbf{a}_\mathbf{s}} = \keys{\mathbf{a}_\mathbf{s}} \setminus \{k\} & \when v_z = 0 \\
                           \mathbf{a}_\mathbf{s}[k] = \mu_{v_o\dots+v_z} &\otherwise \\
                         \end{rcases} &\when \mathbb{Z}_{v_o \dots+ v_z} \subset \mathbb{V}_{\mu} \\
                         \error &\otherwise
                       \end{cases} \\
                       \using l &= \begin{cases}
                         |\mathbf{s}_\mathbf{s}[k]| &\when k \in \keys{\mathbf{s}_\mathbf{s}} \\
                         \mathtt{NONE} &\otherwise
                       \end{cases} \\
                       (\omega'_0, \mathbf{s}') &\equiv \begin{cases}
                         (l, \mathbf{a}) &\when k \ne \error \wedge \mathbf{a} \ne \error \wedge \mathbf{a}_t \le \mathbf{a}_b\\
                         (\mathtt{FULL}, \mathbf{s}) &\when \mathbf{a}_t > \mathbf{a}_b \\
                         (\mathtt{OOB}, \mathbf{s}) &\otherwise
                       \end{cases}
                     \end{aligned}$
  (lr)1-1(lr)2-2   
  `info` = 4       
  $g = 10$         $\begin{aligned}
                       \using \mathbf{t} &= \begin{cases} \mathbf{s} &\when \omega_0 \in \{s, 2^{32} - 1\} \\ (\mathbf{d} \cup \mathbf{x}_\mathbf{n})[\omega_0] &\otherwise \end{cases} \\
                       \using o &= \omega_1 \\
                       \using \mathbf{m} &= \begin{cases}
                         \mathcal{E}(\mathbf{t}_c, \mathbf{t}_b, \mathbf{t}_t, \mathbf{t}_g, \mathbf{t}_m, \mathbf{t}_l, \mathbf{t}_i) &\when \mathbf{t} \ne \none \\
                         \none &\otherwise
                       \end{cases} \\
                       \forall i \in \N_{|\mathbf{m}|} : \mu'_{o + i} &\equiv \begin{cases}
                         \mathbf{m}_i & \when \mathbf{m} \ne \none \wedge \mathbb{Z}_{o \dots+ |\mathbf{m}|} \subset \mathbb{V}^*_{\mu} \\
                         \mu_{o + i} & \otherwise
                       \end{cases} \\
                       \omega'_0 &\equiv \begin{cases}
                         \mathtt{OK} & \when \mathbf{m} \ne \none \wedge \mathbb{Z}_{o \dots+ |\mathbf{m}|} \subset \mathbb{V}^*_{\mu} \\
                         \mathtt{NONE} & \when \mathbf{m} = \none \\
                         \mathtt{OOB} & \otherwise \\
                       \end{cases}
                     \end{aligned}$
  ---------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## B.7 Accumulate Functions {#sec:accumulatefunctions}

This defines a number of functions broadly of the form $(\xi' \in \Z_G, \omega' \in \seq{\N_R}_2, \mu', (\mathbf{x}', \mathbf{y}')) = \Omega_\square(\xi \in \N_G, \omega \in \seq{\N_R}_6, \mu \in \mathbb{M}, (\mathbf{x}\in \mathbf{X}, \mathbf{y}\in \mathbf{X}), \dots)$. Functions which have a result component which is equivalent to the corresponding argument may have said components elided in the description. Functions may also depend upon particular additional parameters. $$\begin{aligned}
  \xi' &\equiv \xi - g\\
  (\omega', \mu', \mathbf{x}', \mathbf{y}') &\equiv \begin{cases}
    (\omega, \mu, \mathbf{x}, \mathbf{y}) &\when \xi < g\\
    (\omega, \mu, \mathbf{x}, \mathbf{y}) \text{ except as indicated below} &\otherwise
  \end{cases}\end{aligned}$$

  ------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                              
  **Identifier**                              
  **Gas usage**                               
  (lr)1-1(lr)2-2                              
  `empower` = 5                               
  $g = 10$                                    $\begin{aligned}
                                                  \using [m, a, v, o, n] &= \omega_{0 \dots 5} \\
                                                  \using \mathbf{g} &= \begin{cases}
                                                    \left\{ (s \mapsto g) \ \where \se_4(s) \concat \se_8(g) = \mathbf{d}_{o+12i\dots+12} \mid i \in \N_n \right\} &\when \mathbb{Z}_{o \dots+ 12n} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}'_p) &= \begin{cases}
                                                    (\mathtt{OK}, \tuple{m, a, v, \mathbf{g}}) &\when \mathbf{g} \ne \error \\
                                                    (\mathtt{OOB}, \mathbf{x}_p) &\otherwise
                                                  \end{cases}
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `assign` = 6                                
  $g = 10$                                    $\begin{aligned}
                                                  \using o &= \omega_1 \\
                                                  \using \mathbf{c} &= \begin{cases}
                                                    \left[\mu_{o + 32i \dots+ 32} \mid i \orderedin \N_\mathsf{Q}\right] &\when \mathbb{Z}_{o \dots+ 32\mathsf{Q}} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}') &= \begin{cases}
                                                    (\mathtt{OK}, \mathbf{x} \exc \mathbf{x}'_\mathbf{c}[\omega_0] = \mathbf{c}) &\when \omega_0 < \mathsf{C} \wedge \mathbf{c} \ne \error \\
                                                    (\mathtt{OOB}, \mathbf{x}) &\when \mathbf{c} = \error \\
                                                    (\mathtt{CORE}, \mathbf{x}) &\otherwise \\
                                                  \end{cases} \\
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `designate` = 7                             
  $g = 10$                                    $\begin{aligned}
                                                  \using o &= \omega_0 \\
                                                  \using \mathbf{v} &= \begin{cases}
                                                    \left[\mu_{o + 336i \dots+ 336} \mid i \orderedin \N_\mathsf{V}\right] &\when \mathbb{Z}_{o \dots+ 336\mathsf{V}} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}') &= \begin{cases}
                                                    (\mathtt{OK}, \mathbf{x} \exc \mathbf{x}'_\mathbf{v} = \mathbf{v}) &\when \mathbf{v} \ne \error \\
                                                    (\mathtt{OOB}, \mathbf{x}) &\otherwise
                                                  \end{cases} \\
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `checkpoint` = 8                            
  $g = 10$                                    $\begin{aligned}
                                                  \mathbf{y'} &\equiv \mathbf{x} \\
                                                  \omega'_0 &\equiv \xi' \bmod 2^{32} \\
                                                  \omega'_1 &\equiv \left\lfloor \xi' \div 2^{32}\right\rfloor
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `new` = 9                                   
  $g = 10$                                    $\begin{aligned}
                                                  \using [o, l, g_l, g_h, m_l, m_h] &= \omega_{0..6} \\
                                                  \using c &= \begin{cases}
                                                    \mu_{o\dots+32} &\when \N_{o\dots+32} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases}\\
                                                  \using g &= 2^{32}\cdot g_h + g_l \\
                                                  \using m &= 2^{32}\cdot m_h + m_l \\
                                                  \using \mathbf{a} \in \mathbb{A} \cup \{\error\} &= \begin{cases}
                                                    (c, \mathbf{s}: \{\}, \mathbf{l}: \{ (c, l) \mapsto [] \}, b: \mathbf{a}_t, g, m) &\when c \ne \error\\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  \using b &= (\mathbf{x}_\mathbf{s})_b - \mathbf{a}_t \\
                                                  (\omega'_0, \mathbf{x}'_i, \mathbf{x}'_\mathbf{n}, (\mathbf{x}'_\mathbf{s})_b) &\equiv \begin{cases}
                                                    (\mathbf{x}_i, \text{check}(\text{bump}(\mathbf{x}_i)), \mathbf{x}_\mathbf{n} \cup \{ \mathbf{x}_i \mapsto \mathbf{a} \}, b) &\when \mathbf{a} \ne \error \wedge b \ge (\mathbf{x}_\mathbf{s})_t \\
                                                    (\mathtt{OOB}, \mathbf{x}_T) &\when c = \error \\
                                                    (\mathtt{CASH}, \mathbf{x}_T) &\otherwise
                                                  \end{cases} \\
                                                  \where \text{bump}(i \in \N_S) &= 2^8 + (i - 2^8 + 42) \bmod (2^{32} - 2^9)
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `upgrade` = 10                              
  $g = 10$                                    $\begin{aligned}
                                                  \using [o, g_h, g_l, m_h, m_l] &= \omega_{0..5} \\
                                                  \using c &= \begin{cases}
                                                    \mu_{o\dots+32} &\when \N_{o \dots+ 32} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  \using g &= 2^{32}\cdot g_h + g_l \\
                                                  \using m &= 2^{32}\cdot m_h + m_l \\
                                                  (\omega'_0, \mathbf{x}'[s]_c, \mathbf{x}'[s]_g, \mathbf{x}'[s]_m) &\equiv \begin{cases}
                                                    (\mathtt{OK}, c, g, m) &\when c \ne \error\\
                                                    (\mathtt{OOB}, \mathbf{x}[s]_c, \mathbf{x}[s]_g, \mathbf{x}[s]_m) &\otherwise
                                                  \end{cases}
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `transfer` = 11                             
  $g = 10 + \omega_1 + 2^{32}\cdot\omega_2$   $\begin{aligned}
                                                  \using (d, a_l, a_h, g_l, g_h, o) &= \omega_{0..6},  \\
                                                  \using a &= 2^{32}\cdot a_h + a_l \\
                                                  \using g &= 2^{32}\cdot g_h + g_l \\
                                                  \using \mathbf{t} \in \mathbb{T} \cup \{\error\} &= \begin{cases}
                                                    (s, d, a, m, g): m = \mu_{o\dots+\mathsf{M}} &\when \N_{o\dots+\mathsf{M}} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  \using b &= (\mathbf{x}_\mathbf{s})_b - a \\
                                                  (\omega'_0, \mathbf{x}'_\mathbf{t}, (\mathbf{x}'_\mathbf{s})_b) &\equiv \begin{cases}
                                                    (\mathtt{OOB}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\when t = \error \\
                                                    (\mathtt{WHO}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen d \not \in \keys{\delta \cup \mathbf{x}_\mathbf{n}} \\
                                                    (\mathtt{LOW}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen g < (\delta \cup \mathbf{x}_\mathbf{n})[d]_m \\
                                                    (\mathtt{HIGH}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen \xi < g \\
                                                    (\mathtt{CASH}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen b < (\mathbf{x}_\mathbf{s})_t \\
                                                    (\mathtt{OK}, \mathbf{x}_\mathbf{t} \doubleplus \mathbf{t}, b) &\otherwise
                                                  \end{cases} \\
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `quit` = 12                                 
  $g = 10 + \omega_1 + 2^{32}\cdot\omega_2$   $\begin{aligned}
                                                  \using [d, o] &= \omega_{0,1} \\
                                                  \using a &= (\mathbf{x}_\mathbf{s})_b - (\mathbf{x}_\mathbf{s})_t + \mathsf{B}_S \\
                                                  \using g &= \xi \\
                                                  \using \mathbf{t} \in \mathbb{T} \cup \{\error,\none\} &= \begin{cases}
                                                    \none &\when d \in \{ s, 2^{32} - 1 \} \\
                                                    (s, d, a, m, g): m = \de(\mu_{o\dots+\mathsf{M}}) &\otherwhen \N_{o\dots+\mathsf{M}} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}'_\mathbf{s}, \mathbf{x}'_\mathbf{t}) &\equiv \begin{cases}
                                                    (\mathtt{OK}, \none, \mathbf{x}_\mathbf{t}),\ \textbf{virtual machine halts} &\when \mathbf{t} = \none \\
                                                    (\mathtt{OOB}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen t = \error \\
                                                    (\mathtt{WHO}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen d \not \in \keys{\delta \cup \mathbf{x}_\mathbf{n}} \\
                                                    (\mathtt{LOW}, \mathbf{x}_\mathbf{t}, (\mathbf{x}_\mathbf{s})_b) &\otherwhen g < (\delta \cup \mathbf{x}_\mathbf{n})[d]_m \\
                                                    (\mathtt{OK}, \none, \mathbf{x}_\mathbf{t} \doubleplus \mathbf{t}),\ \textbf{virtual machine halts} &\otherwise
                                                  \end{cases} \\
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `solicit` = 13                              
  $g = 10$                                    $\begin{aligned}
                                                  \using [o, z] &= \omega_{0, 1} \\
                                                  \using h &= \begin{cases}
                                                    \mu_{o\dots+32} &\when \mathbb{Z}_{o \dots+ 32} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  \using \mathbf{a} &= \begin{cases}
                                                    \mathbf{x}_\mathbf{s} \text{ except: } &\\
                                                    \quad \mathbf{a}_\mathbf{l}[\tup{h, z}] = [] &\when h \ne \error \wedge (h, z) \not\in (\mathbf{x}_\mathbf{s})_\mathbf{l} \\
                                                    \quad \mathbf{a}_\mathbf{l}[\tup{h, z}] = (\mathbf{x}_\mathbf{s})_\mathbf{l}[\tup{h, z}] \doubleplus t &\when (\mathbf{x}_\mathbf{s})_\mathbf{l}[\tup{h, z}] = [x, y] \\
                                                    \error &\otherwise\\
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}'_\mathbf{s}) &\equiv \begin{cases}
                                                    (\mathtt{OOB}, \mathbf{x}_\mathbf{s}) &\when h = \error \\
                                                    (\mathtt{HUH}, \mathbf{x}_\mathbf{s}) &\otherwhen \mathbf{a} = \error \\
                                                    (\mathtt{FULL}, \mathbf{x}_\mathbf{s}) &\otherwhen \mathbf{a}_b < \mathbf{a}_t \\
                                                    (\mathtt{OK}, \mathbf{a}) &\otherwise \\
                                                  \end{cases} \\
                                                \end{aligned}$
  (lr)1-1(lr)2-2                              
  `forget` = 14                               
  $g = 10$                                    $\begin{aligned}
                                                  \using [o, z] &= \omega_{0, 1} \\
                                                  \using h &= \begin{cases}
                                                    \mu_{o\dots+32} &\when \mathbb{Z}_{o \dots+ 32} \subset \mathbb{V}_{\mu} \\
                                                    \error &\otherwise
                                                  \end{cases} \\
                                                  \using \mathbf{a} &= \begin{cases}
                                                    \mathbf{x}_\mathbf{s} \text{ except:} &\\
                                                    \quad \left.
                                                      \begin{aligned}
                                                        \keys{\mathbf{a}_\mathbf{l}} &= \keys{(\mathbf{x}_\mathbf{s})_\mathbf{l}} \setminus \{\tup{h, z}\}\ ,\\[2pt]
                                                        \keys{\mathbf{a}_\mathbf{p}} &= \keys{(\mathbf{x}_\mathbf{s})_\mathbf{p}} \setminus \{h\}
                                                      \end{aligned}
                                                    \ \right\} &\when (\mathbf{x}_\mathbf{s})_\mathbf{l}[h, z] \in \{[], [x, y]\},\ y < t - \mathsf{D} \\
                                                    \quad \mathbf{a}_\mathbf{l}[h, z] = (\mathbf{x}_\mathbf{s})_\mathbf{l}[h, z] \doubleplus t &\when |(\mathbf{x}_\mathbf{s})_\mathbf{l}[h, z]| = 1 \\
                                                    \quad \mathbf{a}_\mathbf{l}[h, z] = [(\mathbf{x}_\mathbf{s})_\mathbf{l}[h, z]_2, t] &\when (\mathbf{x}_\mathbf{s})_\mathbf{l}[h, z] = [x, y, w],\ y < t - \mathsf{D} \\
                                                    \error &\otherwise\\
                                                  \end{cases} \\
                                                  (\omega'_0, \mathbf{x}'_\mathbf{s}) &\equiv \begin{cases}
                                                    (\mathtt{OOB}, \mathbf{x}_\mathbf{s}) &\when h = \error \\
                                                    (\mathtt{HUH}, \mathbf{x}_\mathbf{s}) &\otherwhen \mathbf{a} = \error \\
                                                    (\mathtt{OK}, \mathbf{a}) &\otherwise \\
                                                  \end{cases} \\
                                                \end{aligned}$
  ------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## B.8 Refine Functions {#sec:refinefunctions}

These assume some refine context pair $(\mathbf{m}, \mathbf{e}) \in (\dict{\N}{\mathbf{M}}, \seq{\Y_{\mathsf{W}_S}})$, which are both initially empty.

  -------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------
                             
  **Identifier**             
  **Gas usage**              
  (lr)1-1(lr)2-2             
  `historical_lookup` = 15   
  $g = 10$                   $\begin{aligned}
                                 \using \mathbf{a} &= \begin{cases}
                                   \delta[s] &\when \omega_0 = 2^{32} - 1 \wedge s \in \keys{\delta} \\
                                   \delta[\omega_0] &\when \omega_0 \in \keys{\delta} \\
                                   \none &\otherwise
                                 \end{cases} \\
                                 \using [h_o, b_o, b_z] &= \omega_{1..4} \\
                                 \using h &= \begin{cases}
                                   \mathcal{H}(\mu_{h_o\dots+32}) &\when \mathbb{Z}_{h_o \dots+ 32} \subset \mathbb{V}_{\mu} \\
                                   \error &\otherwise
                                 \end{cases} \\
                                 \using \mathbf{v} &= \Lambda(\mathbf{a}, t, h) \\
                                 \forall i \in \N_{\min(b_z, |\mathbf{v}|)} : \mu'_{b_o + i} &\equiv \begin{cases}
                                   \mathbf{v}_i & \when \mathbf{v} \ne \none \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                                   \mu_{b_o + i} & \otherwise
                                 \end{cases} \\
                                 \omega'_0 &\equiv \begin{cases}
                                   \begin{rcases}
                                     |\mathbf{v}| & \when \mathbf{v} \ne \none \\
                                     \mathtt{NONE} &\otherwise \\
                                   \end{rcases} &\when k \ne \error \wedge \mathbb{Z}_{b_o \dots+ b_z} \subset \mathbb{V}^*_{\mu} \\
                                   \mathtt{OOB} &\otherwise
                                 \end{cases}
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `import` = 16              
  $g = 10$                   $\begin{aligned}
                                 \using \mathbf{v} &= \begin{cases}
                                   \mathbf{i}_{\omega_0} &\when \omega_0 < |\mathbf{i}| \\
                                   \none &\otherwise
                                 \end{cases} \\
                                 \using o &= \omega_1 \\
                                 \using l &= \min(\omega_2, \mathsf{W}_C\mathsf{W}_S) \\
                                 \mu'_{o\dots+l} &\equiv \begin{cases}
                                   \mathbf{v} & \when \mathbf{v} \ne \none \wedge \mathbb{N}_{o \dots+ l} \subset \mathbb{V}^*_{\mu} \\
                                   \mu_{o\dots+l} & \otherwise
                                 \end{cases} \\
                                 \omega'_0 &\equiv \begin{cases}
                                   \mathtt{OOB} &\when \mathbb{Z}_{o \dots+ l} \not\subset \mathbb{V}^*_{\mu} \\
                                   \mathtt{NONE} & \otherwhen \mathbf{v} = \none \\
                                   \mathtt{OK} &\otherwise \\
                                 \end{cases}
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `export` = 17              
  $g = 10$                   $\begin{aligned}
                                 \using p &= \omega_0 \\
                                 \using z &= \min(\omega_1, \mathsf{W}_C\mathsf{W}_S) \\
                                 \using \mathbf{x} &= \begin{cases}
                                   \mathcal{P}_{\mathsf{W}_C\mathsf{W}_S}({\mu}_{p\dots+z}) &\when \N_{p\dots+z} \in \mathbb{V}_\mu\\
                                   \error &\otherwise
                                 \end{cases}\\
                                 (\omega'_0, \mathbf{e}') &\equiv \begin{cases}
                                   (\mathtt{OOB}, \mathbf{e}) &\when \mathbf{x} = \error \\
                                   (\mathtt{FULL}, \mathbf{e}) &\otherwhen \varsigma+|\mathbf{e}| \ge \mathsf{W}_X \\
                                   (\varsigma+ |\mathbf{e}|, \mathbf{e} \doubleplus \mathbf{x}) &\otherwise
                                 \end{cases}
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `machine` = 18             
  $g = 10$                   $\begin{aligned}
                                 \using [p_o, p_z, i] &= \omega_{0 \dots 3} \\
                                 \using \mathbf{p} &= \begin{cases}
                                   \mu_{p_o\dots+p_z} &\when \mathbb{Z}_{p_o \dots+ p_z} \subset \mathbb{V}_{\mu} \\
                                   \error &\otherwise
                                 \end{cases} \\
                                 \using n &= \min(n \in \N, n \not\in \keys{\mathbf{m}}) \\
                                 \using \mathbf{u} &= \tup{\is{\mathbf{V}}{[0, 0, \dots]},\is{\mathbf{A}}{[\none, \none, \dots]}} \\
                                 (\omega'_0, \mathbf{m}) &\equiv \begin{cases}
                                   (\mathtt{OOB}, \mathbf{m}) &\when \mathbf{p} = \error \\
                                   (n, \mathbf{m} \cup \{ n \mapsto \tup{\mathbf{p}, \mathbf{u}, i} \} ) &\otherwise \\
                                 \end{cases} \\
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `peek` = 19                
  $g = 10$                   $\begin{aligned}
                                 \using [n, a, b, l] &= \omega_{0 \dots 4} \\
                                 \using \mathbf{s} &= \begin{cases}
                                   \none &\when n \not\in \keys{\mathbf{m}}\\
                                   \error &\when \N_{b\dots+i} \not\in \mathbb{V}_{\mathbf{m}[n]_\mathbf{u}} \\
                                   \mathbf{m}[n]_{\mathbf{u}_{b\dots+i}} &\otherwise
                                 \end{cases}\\
                                 (\omega'_0, {\mu}') &\equiv \begin{cases}
                                   (\mathtt{OOB}, {\mu}) &\when \mathbf{s} = \error \\
                                   (\mathtt{WHO}, {\mu}) &\when \mathbf{s} = \none \\
                                   (\mathtt{OK}, {\mu}') \ \where {\mu}' = {\mu}\exc {\mu}'_{a\dots+l} = \mathbf{s} &\otherwise
                                 \end{cases} \\
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `poke` = 20                
  $g = 10$                   $\begin{aligned}
                                 \using [n, a, b, l] &= \omega_{0 \dots 4} \\
                                 \using \mathbf{u} &= \begin{cases}
                                   \mathbf{m}[n]_\mathbf{u} &\when n \in \keys{\mathbf{m}} \\
                                   \error &\otherwise\\
                                 \end{cases} \\
                                 \using \mathbf{s} &= \begin{cases}
                                   {\mu}_{a\dots+i} &\when \N_{a\dots+i} \in \mathbb{V}_\mathbf{u}\\
                                   \error &\otherwise
                                 \end{cases}\\
                                 \using \mathbf{u}' &= \mathbf{u} \exc \begin{cases}
                                   (\mathbf{u}'_\mathbf{V})_{b\dots+l} = \mathbf{s} \\
                                   (\mathbf{u}'_\mathbf{A})_{b\dots+l} = [\mathrm{W}, \mathrm{W}, ...]
                                 \end{cases}\\
                                 (\omega'_0, \mathbf{m}') &\equiv \begin{cases}
                                   (\mathtt{OOB}, \mathbf{m}) &\when \mathbf{s} = \error \\
                                   (\mathtt{WHO}, \mathbf{m}) &\otherwhen \mathbf{u} = \error \\
                                   (\mathtt{OK}, \mathbf{m}')\,,\ \where \mathbf{m}' = \mathbf{m} \exc \mathbf{m}'[n]_\mathbf{u} = \mathbf{u}' &\otherwise \\
                                 \end{cases} \\
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `invoke` = 21              
  $g = 10$                   $\begin{aligned}
                                 \using [n, o] &= \omega_{0 \dots 2} \\
                                 \using (g, \mathbf{w}) &= \begin{cases}
                                   (\de_8({\mu}_{o\dots+8}), [\de_4({\mu}_{o+8+4x\dots+4}) \mid x \orderedin \N_{13}]) &\when \N_{o \dots+ 60} \subset \mathbb{V}^*_{{\mu}} \\
                                   (\error, \error) &\otherwise
                                 \end{cases} \\
                                 \using (c, i', g', \mathbf{w}', \mathbf{u}') &= \Psi(\mathbf{m}[n]_\mathbf{p}, \mathbf{m}[n]_i, g, \mathbf{w}, \mathbf{m}[n]_\mathbf{u})\\
                                 \using {\mu}^* &= {\mu}\exc {\mu}^*_{o\dots+60} = \se_8(g') \concat \se([\se_4(x) \mid x \orderedin \mathbf{w}'])\\
                                 \using \mathbf{m}^* &= \mathbf{m} \exc \begin{cases}
                                   \mathbf{m}^*[n]_\mathbf{u} = \mathbf{u}'\\
                                   \mathbf{m}^*[n]_i = \begin{cases}
                                     i' + 1 &\when c \in \{ \host \} \times \N_R\\
                                     i' &\otherwise
                                   \end{cases}
                                 \end{cases}\\
                                 (\omega'_0, \omega'_1, {\mu}', \mathbf{m}') &\equiv \begin{cases}
                                   (\mathtt{OOB}, \omega_1, {\mu}, \mathbf{m}) &\when g = \error \\
                                   (\mathtt{WHO}, \omega_1, {\mu}, \mathbf{m}) &\otherwhen n \not\in \mathbf{m} \\
                                   (\mathtt{HOST}, h, {\mu}^*, \mathbf{m}^*) &\otherwhen c = \host \times h \\
                                   (\mathtt{FAULT}, x, {\mu}^*, \mathbf{m}^*) &\otherwhen c = \fault \times x \\
                                   (\mathtt{PANIC}, \omega_1, {\mu}^*, \mathbf{m}^*) &\otherwhen c = \panic \\
                                   (\mathtt{HALT}, \omega_1, {\mu}^*, \mathbf{m}^*) &\otherwhen c = \halt \\
                                 \end{cases} \\
                               \end{aligned}$
  (lr)1-1(lr)2-2             
  `expunge` = 22             
  $g = 10$                   $\begin{aligned}
                                 \using n &= \omega_{0} \\
                                 (\omega'_0, \mathbf{m}') &\equiv \begin{cases}
                                   (\mathtt{WHO}, \mathbf{m}) &\when n \ne \keys{\mathbf{m}} \\
                                   (\mathbf{m}[n]_i, \mathbf{m} \setminus n) &\otherwise \\
                                 \end{cases} \\
                               \end{aligned}$
  -------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------

# C Serialization Codec {#sec:serialization}

## C.1 Common Terms {#common-terms}

Our codec function $\mathcal{E}$ is used to serialize some term into a sequence of octets. We define the deserialization function $\de = \mathcal{E}^{-1}$ as the inverse of $\mathcal{E}$ and able to decode some sequence into the original value. The codec is designed such that exactly one value is encoded into any given sequence of octets, and in cases where this is not desirable then we use special codec functions.

### C.1.1 Trivial Encodings {#trivial-encodings}

We define the serialization of $\varnothing$ as the empty sequence: $$\se(\none) \equiv []$$

We also define the serialization of an octet-sequence as itself: $$\se(x \in \Y) \equiv x$$

We define anonymous tuples to be encoded as the concatenation of their encoded elements: $$\se(\tup{a, b, \dots}) \equiv \se(a) \concat \se(b) \concat \dots$$

Passing multiple arguments to the serialization functions is equivalent to passing a tuple of those arguments. Formally: $$\begin{aligned}
  \se(a, b, c, \dots) &\equiv \se(\tup{a, b, c, \dots})\end{aligned}$$

### C.1.2 Integer Encoding {#integer-encoding}

We first define the trivial natural number serialization functions which are subscripted by the number of octets of the final sequence. Values are encoded in a regular little-endian fashion. This is utilized for almost all integer encoding across the protocol. Formally: $$\se_{l \in \N}\colon\left\{\begin{aligned}
    \N_{2^{8l}} &\to \Y_l \\
    x &\mapsto \begin{cases}
      [] &\when l = 0 \\
      [x \bmod 256] \concat \se_{l - 1}\left(\left\lfloor \frac{x}{256} \right\rfloor\right) &\otherwise
    \end{cases}
  \end{aligned}\right.$$

We define general natural number serialization, able to encode naturals of up to $2^{64}$, as: $$\se\colon\left\{\begin{aligned}
    \N_{2^{64}} &\to \Y_{1:9} \\
    x &\mapsto \begin{cases}
      [0] &\when x = 0 \\
      \left[2^8-2^{8-l} + \ffrac{x}{2^{8l}}\right] \concat \se_l(x \bmod 2^{8l}) &\when \exists l \in \N_8 : 2^{7l} \le x < 2^{7(l+1)} \\
      [2^8-1] \concat \se_8(x) &\otherwhen x < 2^{64} \\
    \end{cases}
  \end{aligned}\right.$$

Note that at present this is utilized only in encoding the length prefix of variable-length sequences.

### C.1.3 Sequence Encoding {#sequence-encoding}

We define the sequence serialization function $\se(\seq{T})$ for any $T$ which is itself a subset of the domain of $\se$. We simply concatenate the serializations of each element in the sequence in turn: $$\se([i_0, i_1, ...]) \equiv \se(i_0) \concat \se(i_1) \concat \dots$$

Thus, conveniently, fixed length octet sequences (e.g. hashes $\H$ and its variants) have an identity serialization.

### C.1.4 Discriminator Encoding {#discriminator-encoding}

When we have sets of heterogeneous items such as a union of different kinds of tuples or sequences of different length, we require a discriminator to determine the nature of the encoded item for successful deserialization. Discriminators are encoded as a natural and are encoded immediately prior to the item.

We generally use a *length discriminator* which serializing sequence terms which have variable length (e.g. general blobs $\Y$ or unbound numeric sequences $\seq{\N}$) (though this is omitted in the case of fixed-length terms such as hashes $\H$).[^19] In this case, we simply prefix the term its length prior to encoding. Thus, for some term $y \in \tup{x \in \Y, \dots}$, we would generally define its serialized form to be $\se(|x|)\concat\se(x)\concat\dots$. To avoid repetition of the term in such cases, we define the notation $\var{x}$ to mean that the term of value $x$ is variable in size and requires a length discriminator. Formally: $$\var{x} \equiv \tup{|x|, x}\text{ thus }\se(\var{x}) \equiv \se(|x|)\concat\se(x)$$

We also define a convenient discriminator operator $\maybe{x}$ specifically for terms defined by some serializable set in union with $\none$ (generally denoted for some set $S$ as $S\bm{?}$): $$\begin{aligned}
  \maybe{x} \equiv \begin{cases}
    0 &\when x = \none \\
    (1, x) &\otherwise
  \end{cases}\end{aligned}$$

### C.1.5 Bit Sequence Encoding {#bit-sequence-encoding}

A sequence of bits $b \in \mathbb{B}$ is a special case since encoding each individual bit as an octet would be very wasteful. We instead pack the bits into octets in order of least significant to most, and arrange into an octet stream. In the case of a variable length sequence, then the length is prefixed as in the general case. $$\begin{aligned}
  \se(b \in \mathbb{B}) &\equiv \begin{cases}
    [] &\when b = [] \\
    \left[\sum\limits_{i=0}^{\min(8, |b|)}{b_i\cdot 2^i}\right] \concat \se(b_{8\dots}) &\otherwise\\
  \end{cases}\end{aligned}$$

### C.1.6 Dictionary Encoding {#dictionary-encoding}

In general, dictionaries are placed in the Merkle trie directly (see appendix [28](#sec:merklization){reference-type="ref" reference="sec:merklization"} for details). However, small dictionaries may reasonably be encoded as a sequence of pairs ordered by the key. Formally: $$\forall K, V: \se(d \in \dict{K}{V}) \equiv \se(\var{\orderby{k}{\tup{\se(k), \se(d[k])} \mid k \in \keys{d}}})$$

## C.2 Block Serialization {#block-serialization}

A block $\mathbf{B}$ is serialized as a tuple of its elements in regular order, as implied in equations [\[eq:block\]](#eq:block){reference-type="ref" reference="eq:block"}, [\[eq:extrinsic\]](#eq:extrinsic){reference-type="ref" reference="eq:extrinsic"} and [\[eq:header\]](#eq:header){reference-type="ref" reference="eq:header"}. For the header, we define both the regular serialization and the unsigned serialization $\se_U$. Formally: $$\begin{aligned}
  \se(\mathbf{B}) &= \se\,\left\lparen\;\begin{aligned}
    &\mathbf{H},\ 
    \var{\xttickets},\ 
    \var{[(r, \se_4(a), [(v, \se_2(i), s) \mid (v, i, s) \orderedin \mathbf{j}]) \mid (r, a, \mathbf{j}) \orderedin \mathbf{v}]}, \var{\mathbf{c}}, \var{\mathbf{f}},\ \\
    &\var{[\tup{s, \var{p}} \mid \tup{s, p} \orderedin \xtpreimages]},\ 
    \var{[\tup{a, f, \se_2(v), s} \mid \tup{a, f, v, s} \orderedin \xtassurances]},\ \\
    &\var{[\tup{w, \se_4(t), \var{a}} \mid \tup{w, t, a} \orderedin \xtguarantees]}
  \end{aligned}\;\right\rparen \\
  \nonumber &\quad \where \xtdisputes \equiv (\mathbf{v}, \mathbf{c}, \mathbf{f}) \\
  \se(\mathbf{H}) &= \se_U(\mathbf{H})\concat\se(\mathbf{H}_s) \\
  \se_U(\mathbf{H}) &= \se(\mathbf{H}_p,\mathbf{H}_r,\mathbf{H}_x)\concat\se_4(\mathbf{H}_t)\concat\se(\maybe{\mathbf{H}_e},\maybe{\mathbf{H}_w},\var{\mathbf{H}_o},\se_2(\mathbf{H}_i),\mathbf{H}_v)\\
  \se(x \in \mathbb{X}) &\equiv \se(x_a, x_s, x_b, x_l)\concat\se_4(x_t)\concat\se(\maybe{x_p})\\
  \se(x \in \mathbb{S}) &\equiv \se(x_h) \concat \se_4(x_l)\concat\se(x_u, x_e) \\
  \se(x \in \mathbb{L}) &\equiv \se_4(x_s)\concat\se(x_c, x_l)\concat\se_8(x_g)\concat\se(O(x_o))\\
  \se(x \in \mathbb{W}) &\equiv \se(x_s, x_x, x_c, x_a, \var{x_o}, \var{x_r}) \\
  \se(x \in \mathbb{P}) &\equiv \se(\var{x_\wpNauthtoken}, \se_4(x_\wpNauthcodehost), x_\wpNauthcodehash, \var{x_\wpNauthparam}, x_\wpNcontext, \var{x_\wpNworkitems}) \\
  % TODO: \se_4(i) should be just \se(i), but we should wait for this to be written.
  \se(x \in \mathbb{I}) &\equiv \se(\se_4(x_s), x_c, \var{x_\mathbf{y}}, \se_8(x_g), \var{\sq{(h, \se_2(i)) \mid (h, i) \orderedin x_\mathbf{i}}}, \var{\sq{(h, \se_4(i)) \mid (h, i) \orderedin x_\mathbf{x}}}, \se_2(x_e)) \\
  \se(x \in \mathbb{C}) &\equiv \se(x_\mathbf{y}, x_r) \\
  O(o \in \mathbb{J} \cup \Y) &\equiv \begin{cases}
    (0, \var{o}) &\when o \in \Y \\
    1 &\when o = \infty \\
    2 &\when o = \panic \\
    3 &\when o = \token{BAD} \\
    4 &\when o = \token{BIG} \\
  \end{cases}\end{aligned}$$

Note the use of $O$ above to succinctly encode the result of a work item and the slight transformations of $\xtguarantees$ and $\xtpreimages$ to take account of the fact their inner tuples contain variable-length sequence terms $a$ and $p$ which need length discriminators.

# D State Merklization {#sec:statemerklization}

The Merklization process defines a cryptographic commitment from which arbitrary information within state may be provided as being authentic in a concise and swift fashion. We describe this in two stages; the first defines a mapping from 32-octet sequences to (unlimited) octet sequences in a process called *state serialization*. The second forms a 32-octet commitment from this mapping in a process called *Merklization*.

## D.1 Serialization {#serialization}

The serialization of state primarily involves placing all the various components of $\sigma$ into a single mapping from 32-octet sequence *state-keys* to octet sequences of indefinite length. The state-key is constructed from a hash component and a chapter component, equivalent to either the index of a state component or, in the case of the inner dictionaries of $\delta$, a service index.

We define the state-key constructor functions $C$ as: $$C\colon\left\{\begin{aligned}
    \N_{2^8} \cup (\N_{2^8}, \N_S) \cup \tup{\N_S, \Y} &\to \H \\
    i \in \N_{2^8} &\mapsto [i, 0, 0, \dots] \\
    (i, s \in \N_S) &\mapsto [i, n_0, n_1, n_2, n_3, 0, 0, \dots]\ \where n = \se_4(s) \\
    (s, h) &\mapsto [n_0, h_0, n_1, h_1, n_2, h_2, n_3, h_3, h_4, h_5, \dots, h_{27}]\ \where n = \se_4(s)
  \end{aligned}
  \right.$$

The state serialization is then defined as the dictionary built from the amalgamation of each of the components. Cryptographic hashing ensures that there will be no duplicate state-keys given that there are no duplicate inputs to $C$. Formally, we define $T$ which transforms some state $\sigma$ into its serialized form: $$T(\sigma) \equiv \left\{\begin{aligned}
    &&C(1) &\mapsto \se([\var{x}\mid x\orderedin \alpha]) \;, \\
    &&C(2) &\mapsto \se(\varphi) \;, \\
    &&C(3) &\mapsto \se(\var{[(h, \se_M(\mathbf{b}), s, \var{\mathbf{p}})\mid (h, \mathbf{b}, s, \mathbf{p})\orderedin \beta]}) \;, \\
    &&C(4) &\mapsto \se\left(\tup{\gamma_\mathbf{k}, \gamma_z, \left\{\,\begin{aligned}
      0\ &\when \gamma_\mathbf{s} \in \seq{\mathbb{C}}_\mathsf{E}\\
      1\ &\when \gamma_\mathbf{s} \in \seq{\H_B}_\mathsf{E}\\
    \end{aligned}\right\}, \gamma_\mathbf{s},
    \var{\gamma_\mathbf{a}}}\right) \;, \\
    &&C(5) &\mapsto \se(\var{\orderby{x}{x \in \goodset}}, \var{\orderby{x}{x \in \badset}}, \var{\orderby{x}{x \in \wonkyset}}, \var{\orderby{x}{x \in \offenders}}) \;, \\
    &&C(6) &\mapsto \se(\eta) \;, \\
    &&C(7) &\mapsto \se(\iota) \;, \\
    &&C(8) &\mapsto \se(\kappa) \;, \\
    &&C(9) &\mapsto \se(\lambda) \;, \\
    &&C(10) &\mapsto \se([\maybe{(w, \se_4(t))} \mid (w, t) \orderedin \rho]) \;, \\
    &&C(11) &\mapsto \se_4(\tau) \;, \\
    &&C(12) &\mapsto \se_4(\chi_m, \chi_a, \chi_v) \concat \se(\chi_\mathbf{g}) \;, \\
    &&C(13) &\mapsto \se_4(\pi) \;, \\
    \forall (s \mapsto \mathbf{a}) \in \delta: &&C(255, s) &\mapsto \mathbf{a}_c \concat \se_8(\mathbf{a}_b, \mathbf{a}_g, \mathbf{a}_m, \mathbf{a}_l) \concat \se_4(\mathbf{a}_i) \;, \\
    \forall (s \mapsto \mathbf{a}) \in \delta, (h \mapsto \mathbf{v}) \in \mathbf{a}_\mathbf{s}: &&C(s, h) &\mapsto \mathbf{v} \;, \\
    \forall (s \mapsto \mathbf{a}) \in \delta, (h \mapsto \mathbf{p}) \in \mathbf{a}_\mathbf{p}: &&C(s, h) &\mapsto \mathbf{p} \;, \\
    \forall (s \mapsto \mathbf{a}) \in \delta, (\tup{h, l} \mapsto \mathbf{t}) \in \mathbf{a}_\mathbf{l}: &&C(s, \se_4(l) \concat (\lnot h_{4\dots})) &\mapsto \se(\var{[\se_4(x) \mid x \orderedin \mathbf{t}]})
  \end{aligned}\right\}$$

Note that most rows describe a single mapping between key derived from a natural and the serialization of a state component. However, the final four rows each define sets of mappings since these items act over all service accounts and in the case of the final three rows, the keys of a nested dictionary with the service.

Also note that all non-discriminator numeric serialization in state is done in fixed-length according to the size of the term.

## D.2 Merklization {#merklization}

With $T$ defined, we now define the rest of $\mathcal{M}_\sigma$ which primarily involves transforming the serialized mapping into a cryptographic commitment. We define this commitment as the root of the binary Patricia Merkle Trie with a format optimized for modern compute hardware, primarily by optimizing sizes to fit succinctly into typical memory layouts and reducing the need for unpredictable branching.

### D.2.1 Node Encoding and Trie Identification {#node-encoding-and-trie-identification}

We identify (sub-)tries as the hash of their root node, with one exception: empty (sub-)tries are identified as the zero-hash, $\H^0$.

Nodes are fixed in size at 512 bit (64 bytes). Each node is either a branch or a leaf. The first bit discriminate between these two types.

In the case of a branch, the remaining 511 bits are split between the two child node hashes, using the last 255 bits of the 0-bit (left) sub-trie identity and the full 256 bits of the 1-bit (right) sub-trie identity.

Leaf nodes are further subdivided into embedded-value leaves and regular leaves. The second bit of the node discriminates between these.

In the case of an embedded-value leaf, the remaining 6 bits of the first byte are used to store the embedded value size. The following 31 bytes are dedicated to the first 31 bytes of the key. The last 32 bytes are defined as the value, filling with zeroes if its length is less than 32 bytes.

In the case of a regular leaf, the remaining 6 bits of the first byte are zeroed. The following 31 bytes store the first 31 bytes of the key. The last 32 bytes store the hash of the value.

Formally, we define the encoding functions $B$ and $L$: $$\begin{aligned}
  B&\colon\left\{\begin{aligned}
    (\H, \H) &\to \mathbb{B}_{512}\\
    (l, r) &\mapsto [0] \frown \text{bits}(l)_{1\dots} \frown \text{bits}(r)
  \end{aligned}\right.\\
  L&\colon\left\{\begin{aligned}
    (\H, \Y) &\to \mathbb{B}_{512}\\
    (k, v) &\mapsto \begin{cases}
      [1, 0] \frown \text{bits}(\se_1(|v|))_{\dots6} \frown \text{bits}(k)_{\dots248} \frown \text{bits}(v) \frown [0, 0, \dots] &\when |v| \le 32\\
      [1, 1, 0, 0, 0, 0, 0, 0] \frown \text{bits}(k)_{\dots248} \frown \text{bits}(\mathcal{H}(v)) &\otherwise
    \end{cases}
  \end{aligned}\right.\end{aligned}$$

We may then define the basic Merklization function $\mathcal{M}_\sigma$ as: $$\begin{aligned}
  \mathcal{M}_\sigma(\sigma) &\equiv M(\{ (\text{bits}(k) \mapsto \tup{k, v}) \mid (k \mapsto v) \in T(\sigma) \})\\
  M(d: \dict{\mathbb{B}}{(\H, \Y)}) &\equiv \begin{cases}
    \H^0 &\when |d| = 0\\
    \mathcal{H}(\text{bits}^{-1}(L(k, v))) &\when \mathcal{V}(d) = \{ (k, v) \}\\
    \mathcal{H}(\text{bits}^{-1}(B(M(l), M(r)))) &\otherwise, \where \forall b, p: (b \mapsto p) \in d \Leftrightarrow (b_{1\dots} \mapsto p) \in \begin{cases}
      l &\when b_0 = 0 \\
      r &\when b_0 = 1
    \end{cases}
  \end{cases}\end{aligned}$$

# E General Merklization {#sec:merklization}

## E.1 Binary Merkle Trees {#binary-merkle-trees}

The Merkle tree is a cryptographic data structure yielding a hash commitment to a specific sequence of values. It provides $O(N)$ computation and $O(\log(N))$ proof size for inclusion. This *well-balanced* formulation ensures that the maximum depth of any leaf is minimal and that the number of leaves at that depth is also minimal.

The underlying function for our Merkle trees is the *node* function $N$, which accepts some sequence of blobs of some length $n$ and provides either such a blob back or a hash: $$N\colon\left\{\begin{aligned}
    (\seq{\Y_n}, \Y \to \H) &\to \Y_n \cup \H \\
    (\mathbf{v}, H) &\mapsto \begin{cases}
      \H_0 &\when |\mathbf{v}| = 0 \\
      \mathbf{v}_0 &\when |\mathbf{v}| = 1 \\
      H(\token{\$node} \concat N(\mathbf{v}_{\dots\ceil{\nicefrac{|\mathbf{v}|}{2}}}, H) \concat N(\mathbf{v}_{\ceil{\nicefrac{|\mathbf{v}|}{2}}\dots}, H)) &\otherwise
    \end{cases}
  \end{aligned}\right.\label{eq:merklenode}$$

The astute reader will realize that if our $\Y_n$ happens to be equivalent $\H$ then this function will always evaluate into $\H$. That said, for it to be secure care must be taken to ensure there is no possibility of preimage collision. For this purpose we include the hash prefix $\token{\$node}$ to minimize the chance of this; simply ensure any items are hashed with a different prefix and the system can be considered secure.

We also define the *trace* function $T$, which returns each opposite node from top to bottom as the tree is navigated to arrive at some leaf corresponding to the item of a given index into the sequence. It is useful in creating justifications of data inclusion. $$\begin{aligned}
    T\colon\left\{\begin{aligned}
      (\seq{\Y_n}, \N_{|\mathbf{v}|}, \Y \to \H)\ &\to \seq{\Y_n \cup \H}\\
      (\mathbf{v}, i, H) &\mapsto \begin{cases}
        [N(P^\bot(\mathbf{v}, i), H)] \concat T(P^\top(\mathbf{v}, i), i - P_I(\mathbf{v}, i), H) &\when |\mathbf{v}| > 1\\
        [] &\otherwise
      \end{cases}
    \end{aligned}\right.\\
    \where\ \left\{\begin{aligned}
      P^s(\mathbf{v}, i) &\equiv \begin{cases}
        \mathbf{v}_{\dots\ceil{\nicefrac{|\mathbf{v}|}{2}}} &\when (i < \ceil{\nicefrac{|\mathbf{v}|}{2}}) = s\\
        \mathbf{v}_{\ceil{\nicefrac{|\mathbf{v}|}{2}}\dots} &\otherwise
      \end{cases}\\
      P_I(\mathbf{v}, i) &\equiv \begin{cases}
        0 &\when i < \ceil{\nicefrac{|\mathbf{v}|}{2}} \\
        \ceil{\nicefrac{|\mathbf{v}|}{2}} &\otherwise
      \end{cases}
    \end{aligned}\right.
  \end{aligned}$$

From this we define our other Merklization functions.

### E.1.1 Well-Balanced Tree {#well-balanced-tree}

We define the well-balanced binary Merkle function as $\mathcal{M}_B$: $$\mathcal{M}_B\colon \left\{\begin{aligned}\label{eq:simplemerkleroot}
      (\seq{\Y}, \Y \to \H) &\to \H \\
      (\mathbf{v}, H) &\mapsto \begin{cases}
        H(\mathbf{v}_0) &\when |\mathbf{v}| = 1 \\
        N(\mathbf{v}, H) &\otherwise
      \end{cases} \\
    \end{aligned}\right.$$

This is suitable for creating proofs on data which is not much greater than 32 octets in length since it avoids hashing each item in the sequence. For sequences with larger data items, it is better to hash them beforehand to ensure proof-size is minimal since each proof will generally contain a data item.

Note: In the case that no hash function argument $H$ is supplied, we may assume the Blake 2b hash function, $\mathcal{H}$.

### E.1.2 Constant-Depth Tree {#constant-depth-tree}

We define the constant-depth binary Merkle function as $\mathcal{M}$ and the corresponding justification generation function as $\mathcal{J}$, with the latter having an optional subscript $x$, which limits the justification to only those nodes required to justify inclusion of a well-aligned subtree of (maximum) size $2^x$: $$\begin{aligned}
\label{eq:constantdepthmerkleroot}
  \mathcal{M}&\colon \left\{\begin{aligned}
    (\seq{\Y}, \Y \to \H) &\to \H\\
    (\mathbf{v}, H) &\mapsto N(C(\mathbf{v}, H), H)
  \end{aligned}\right.\\
  \mathcal{J}&\colon \left\{\begin{aligned}\label{eq:constantdepthmerklejust}
    (\seq{\Y}, \N_{|\mathbf{v}|}, \Y \to \H) &\to \seq{\H}\\
    (\mathbf{v}, i, H) &\mapsto T(C(\mathbf{v}, H), i, H)
  \end{aligned}\right.\\
  \mathcal{J}_x&\colon \left\{\begin{aligned}\label{eq:constantdepthsubtreemerklejust}
    (\seq{\Y}, \N_{|\mathbf{v}|}, \Y \to \H) &\to \seq{\H}\\
    (\mathbf{v}, i, H) &\mapsto T(C(\mathbf{v}, H), i, H)_{\dots\max(0, \ceil{\log_2(\max(1, |\mathbf{v}|)) - x})}
  \end{aligned}\right.\end{aligned}$$

For the latter justification to be acceptable, we must assume the target observer knows not merely the value of the item at the given index, but also all other items within its $2^x$ size subtree.

As above, we may assume a default value for $H$ of the Blake 2b hash function, $\mathcal{H}$.

In all cases, a constancy preprocessor function $C$ is applied which hashes all data items with a fixed prefix and then pads them to the next power of two with the zero hash $\mathbb{H}_0$: $$C\colon\left\{\begin{aligned}
    (\seq{\Y}, \Y \to \H) &\to \seq{\H}\\
    (\mathbf{v}, H) &\mapsto \mathbf{v}' \ \where \left\{\; \begin{aligned}
      |\mathbf{v}'| &= 2^{\ceil{\log_2(\max(1, |\mathbf{v}|))}}\\
      \mathbf{v}'_i &= \begin{cases}
        H(\token{\$leaf}\frown\mathbf{v}_i) &\when i < |\mathbf{v}|\\
        \mathbb{H}_0 &\otherwise \\
      \end{cases}
    \end{aligned}\right.
  \end{aligned}\right.$$

## E.2 Merkle Mountain Ranges {#sec:mmr}

The Merkle mountain range ([mmr]{.smallcaps}) is an append-only cryptographic data structure which yields a commitment to a sequence of values. Appending to an [mmr]{.smallcaps} and proof of inclusion of some item within it are both $O(\log(N))$ in time and space for the size of the set.

We define a Merkle mountain range as being within the set $\seq{\H?}$, a sequence of peaks, each peak the root of a Merkle tree containing $2^i$ items where $i$ is the index in the sequence. Since we support set sizes which are not always powers-of-two-minus-one, some peaks may be empty, $\none$ rather than a Merkle root.

Since the sequence of hashes is somewhat unwieldy as a commitment, Merkle mountain ranges are themselves generally hashed before being published. Hashing them removes the possibility of further appending so the range itself is kept on the system which needs to generate future proofs.

We define the append function $\mathcal{A}$ as: $$\begin{aligned}
    \label{eq:mmrappend}
    \mathcal{A}&\colon\left\{\,\begin{aligned}
      (\seq{\H?}, \H, \Y\to\H) &\to \seq{\H?}\\
      (\mathbf{r}, l, H) &\mapsto P(\mathbf{r}, l, 0, H)
    \vphantom{x'_i}\end{aligned}\right.\\
    \where P&\colon\left\{\,\begin{aligned}
      (\seq{\H?}, \H, \N, \Y\to\H) &\to \seq{\H?}\\
      (\mathbf{r}, l, n, H) &\mapsto \begin{cases}
        \mathbf{r} \doubleplus l &\when n \ge |\mathbf{r}|\\
        R(\mathbf{r}, n, l) &\when n < |\mathbf{r}| \wedge \mathbf{r}_n = \none\\
        P(R(\mathbf{r}, n, \none), H(\mathbf{r}_n \concat l), n + 1, H) &\otherwise
      \end{cases}
    \vphantom{x'_i}\end{aligned}\right.\\
    \also R&\colon\left\{\,\begin{aligned}
      (\seq{T}, \N, T) &\to \seq{T}\\
      (\mathbf{s}, i, v) &\mapsto \mathbf{s}'\ \where \mathbf{s}' = \mathbf{s} \exc \mathbf{s}'_i = v
    \vphantom{x'_i}\end{aligned}\right.
  \end{aligned}$$

We define the [mmr]{.smallcaps} encoding function as $\se_M$: $$\se_M\colon\left\{\,\begin{aligned}
    \seq{\H?} &\to \Y \\
    \mathbf{b} &\mapsto \se(\var{[\maybe{x}\mid x \orderedin \mathbf{b}]})
  \vphantom{x'_i}\end{aligned}\right.$$

# F Shuffling {#sec:shuffle}

The Fisher-Yates shuffle function is defined formally as: $$\label{eq:suffle}
  \forall T, l \in \N: \mathcal{F}\colon\left\{\begin{aligned}
    (\seq{T}_l, \seq{\N}_{l:}) &\to \seq{T}_l\\
    (\mathbf{s}, \mathbf{r}) &\mapsto \begin{cases}
      [\mathbf{s}_{\mathbf{r}_0 \bmod l}] \frown \mathcal{F}(\mathbf{s}'_{\dots l-1}, \mathbf{r}_{1\dots})\ \where \mathbf{s}' = \mathbf{s} \exc \mathbf{s'}_{\mathbf{r}_0 \bmod l} = \mathbf{s}_{l - 1} &\when \mathbf{s} \ne []\\
      [] &\otherwise
    \end{cases}
  \end{aligned}\right.$$

Since it is often useful to shuffle a sequence based on some random seed in the form of a hash, we provide a secondary form of the shuffle function $\mathcal{F}$ which accepts a 32-byte hash instead of the numeric sequence. We define $\mathcal{Q}$, the numeric-sequence-from-hash function, thus: $$\begin{aligned}
  \forall l \in \N:\ \mathcal{Q}_l&\colon\left\{\begin{aligned}
    \H &\to \seq{\N_l}\\
    h &\mapsto [\de_4(\mathcal{H}(h \frown \se_4(\lfloor \nicefrac{i}{8}\rfloor))_{4i \bmod 32 \dots+4}) \mid i \orderedin \N_l]
  \end{aligned}\right.\\
  \label{eq:sequencefromhash}
  \forall T, l \in \N:\ \mathcal{F}&\colon\left\{\begin{aligned}
    (\seq{T}_l, \H) &\to \seq{T}_l\\
    (\mathbf{s}, h) &\mapsto \mathcal{F}(\mathbf{s}, \mathcal{Q}_l(h))
  \end{aligned}\right.\end{aligned}$$

# G Bandersnatch Ring VRF {#sec:bandersnatch}

The Bandersnatch curve is defined by [@cryptoeprint:2021/1152].

The singly-contextualized Bandersnatch Schnorr-like signatures $\bandersig{k}{c}{m}$ are defined as a formulation under the *ietf* [vrf]{.smallcaps} template specified by [@hosseini2024bandersnatch] (as IETF VRF) and further detailed by [@rfc9381].

$$\begin{aligned}
  \bandersig{k \in \H_B}{c \in \H}{m \in \Y} \subset \Y_{96} &\equiv \{ x \mid x \in \Y_{96}, \text{verify}(k, c, m, \text{decode}(x_{\dots32}), \text{decode}(x_{32\dots})) = \top \}  \\
  \banderout{s \in \bandersig{k}{c}{m}} \in \H &\equiv \text{hashed\_output}(\text{decode}(x_{\dots32}) \mid x \in \bandersig{k}{c}{m})\end{aligned}$$

The singly-contextualized Bandersnatch Ring[vrf]{.smallcaps} proofs $\bandersnatch{r}{c}{m}$ are a zk-[snark]{.smallcaps}-enabled analogue utilizing the Pedersen [vrf]{.smallcaps}, also defined by [@hosseini2024bandersnatch] and further detailed by [@cryptoeprint:2023/002].

$$\begin{aligned}
  \mathcal{O}(\seq{\H_B}) \in \Y_R &\equiv \text{KZG\_commitment}(\seq{\H_B})  \\
  \bandersnatch{r \in \Y_R}{c \in \H}{m \in \Y} \subset \Y_{784} &\equiv \{ x \mid x \in \Y_{784}, \text{verify}(r, c, m, \text{decode}(x_{\dots32}), \text{decode}(x_{32\dots})) = \top \}  \\
  \banderout{p \in \bandersnatch{r}{c}{m}} \in \H &\equiv \text{hashed\_output}(\text{decode}(x_{\dots32}) \mid x \in \bandersnatch{r}{c}{m})\end{aligned}$$

Note that in the case a key $\H_B$ has no corresponding Bandersnatch point when constructing the ring, then the Bandersnatch *padding point* as stated by [@hosseini2024bandersnatch] should be substituted.

# H Erasure Coding {#sec:erasurecoding}

The foundation of the data-availability and distribution system of JAM is a systematic Reed-Solomon erasure coding function in [gf]{.smallcaps}(16) of rate 342:1023, the same transform as done by the algorithm of [@lin2014novel]. We use a little-endian $\Y_2$ form of the 16-bit [gf]{.smallcaps} points with a functional equivalence given by $\se_2$. From this we may assume the encoding function $\mathcal{C}: \seq{\Y_2}_{342} \to \seq{\Y_2}_{1023}$ and the recovery function $\mathcal{R}: \powset[342]{\tuple{\Y_2, \N_{1023}}} \to \seq{\Y_2}_{342}$. Encoding is done by extrapolating a data blob of size 684 octets (provided in $\mathcal{C}$ here as 342 octet pairs) into 1,023 octet pairs. Recovery is done by collecting together any distinct 342 octet pairs, together with their indices, and transforming this into the original sequence of 342 octet pairs.

Practically speaking, this allows for the efficient encoding and recovery of data whose size is a multiple of 684 octets. Data whose length is not divisible by 684 must be padded (we pad with zeroes). We use this erasure-coding in two contexts within the JAM protocol; one where we encode variable sized (but typically very large) data blobs for the Audit DA and block-distribution system, and the other where we encode much smaller fixed-size data *segments* for the Import DA system.

For the Import DA system, we deal with an input size of 4,104 octets resulting in data-parallelism of order six. We may attain a greater degree of data parallelism if encoding or recovering more than one segment at a time though for recovery, we may be restricted to requiring each segment to be formed from the same set of indices (depending on the specific algorithm).

## H.1 Blob Encoding and Recovery {#blob-encoding-and-recovery}

We assume some data blob $\mathbf{d} \in \Y_{684k}, k \in \N$. We are able to express this as a whole number of $k$ pieces each of a sequence of 684 octets. We denote these (data-parallel) pieces $\mathbf{p} \in \seq{\Y_{684}} = \text{unzip}_{684}(\mathbf{p})$. Each piece is then reformed as 342 octet pairs and erasure-coded using $\mathcal{C}$ as above to give 1,023 octet pairs per piece.

The resulting matrix is grouped by its pair-index and concatenated to form 1,023 *chunks*, each of $k$ octet-pairs. Any 342 of these chunks may then be used to reconstruct the original data $\mathbf{d}$.

Formally we begin by defining four utility functions for splitting some large sequence into a number of equal-sized sub-sequences and for reconstituting such subsequences back into a single large sequence: $$\begin{aligned}
  \forall n \in \N, k \in \N :\ &\text{split}_n(\mathbf{d} \in \Y_{k\cdot n}) \in \seq{\Y_n}_k \equiv \sq{\mathbf{d}_{0\dots+n}, \mathbf{d}_{n\dots+n}, \cdots, \mathbf{d}_{(k-1)n\dots+n}} \\
  \forall n \in \N, k \in \N :\ &\text{join}_n(\mathbf{c} \in \seq{\Y_n}_k) \in \Y_{k\cdot n} \equiv \mathbf{c}_0 \concat \mathbf{c}_1 \concat \dots \\
  \forall n \in \N, k \in \N :\ &\text{unzip}_n(\mathbf{d} \in \Y_{k\cdot n}) \in \seq{\Y_n}_k \equiv \sq{ [\mathbf{d}_{j.k + i} \mid j \orderedin \N_n] \mid i \orderedin \N_k} \\
  \forall n \in \N, k \in \N :\ &\text{lace}_n(\mathbf{c} \in \seq{\Y_n}_k) \in \Y_{k\cdot n} \equiv \mathbf{d} \ \where \forall i \in \N_k, j \in \N_n: \mathbf{d}_{j.k + i} = (\mathbf{c}_i)_j\end{aligned}$$

We define the transposition operator hence: $$\label{eq:transpose}
  {}^\text{T}[[\mathbf{x}_{0, 0}, \mathbf{x}_{0, 1}, \mathbf{x}_{0, 2}, \dots], [\mathbf{x}_{1, 0}, \mathbf{x}_{1, 1}, \dots], \dots] \equiv [[\mathbf{x}_{0, 0}, \mathbf{x}_{1, 0}, \mathbf{x}_{2, 0}, \dots], [\mathbf{x}_{0, 1}, \mathbf{x}_{1, 1}, \dots], \dots]$$

We may then define our erasure-code chunking function which accepts an arbitrary sized data blob whose length divides wholly into 684 octets and results in 1,023 sequences of sequences each of smaller blobs: $$\label{eq:erasurecoding}
  \mathcal{C}_{k \in \N}\colon\left\{\begin{aligned}
    \Y_{684k} &\to \seq{\Y_{2k}}_{1023} \\
    \mathbf{d} &\mapsto [ \text{join}(\mathbf{c}) \mid \mathbf{c} \orderedin {}^{\text{T}}[\mathcal{C}(\mathbf{p}) \mid \mathbf{p} \orderedin \text{unzip}_{684}(\mathbf{d})] ]
  \end{aligned}\right.$$

The original data may be reconstructed with any 342 of the 1,023 resultant items (along with their indices). If the original 342 items are known then reconstruction is just their concatenation. $$\label{eq:erasurecodinginv}
  \mathcal{R}_{k \in \N}\colon\left\{\begin{aligned}
    \{(\Y_{2k}, \N_{1023})\}_{342} &\to \Y_{684k} \\
    \mathbf{c} &\mapsto \begin{cases}
      \se([\mathbf{x} \mid (\mathbf{x}, i) \orderedin \mathbf{c}]) &\when [i \mid (\mathbf{x}, i) \orderedin \mathbf{c}] = [0, 1, \dots 341]\\
      \text{lace}_k([
        \mathcal{R}([(\text{split}_2(\mathbf{x})_p, i) \mid (\mathbf{x}, i) \orderedin \mathbf{c}])
      \mid p \in \N_k &\text{always}\\
    \end{cases}
    ])
%      [ \mathcal{R}(\mathbf{y}, i) \mid \mathbf{y} \orderedin \transpose[ \spl_2(\mathbf{x}) \mid (\mathbf{x}, i) \orderedin \mathbf{c}] ]
  \end{aligned}\right.$$

Segment encoding/decoding may be done using the same functions albeit with a constant $k = 6$.

## H.2 Code Word representation {#code-word-representation}

For the sake of brevity we call each octet pair a *word*. The code words (including the message words) are treated as element of $\mathbb{F}_{2^{16}}$ finite field. The field is generated as an extension of $\mathbb{F}_2$ using the irreducible polynomial: $$x^{16} + x^5 + x^3 + x^2 + 1$$

Hence: $$\mathbb{F}_{16} \equiv \frac{\mathbb{F}_2[x]}{x^{16}} + x^5 + x^3 + x^2 + 1$$

We name the generator of $\frac{\mathbb{F}_{16}}{\mathbb{F}_2}$, the root of the above polynomial, $\alpha$ as such: $\mathbb{F}_{16} = \mathbb{F}_2(\alpha)$.

Instead of using the standard basis $\{1, \alpha, \alpha^2, \dots, \alpha^{15}\}$, we opt for a representation of $\mathbb{F}_{16}$ which performs more efficiently for the encoding and the decoding process. To that aim, we name this specific representation of $\mathbb{F}_{16}$ as $\tilde{\mathbb{F}}_{16}$ and define it as a vector space generated by the following Cantor basis:

::: center
  ---------- --------------------------------------------------------------------------------------------------------------------------------------------
  $v_0$      $1$
  $v_1$      $\alpha^{15} + \alpha^{13} + \alpha^{11} + \alpha^{10} + \alpha^7
                 + \alpha^6 + \alpha^3 + \alpha$
  $v_2$      $\alpha^{13} + \alpha^{12} + \alpha^{11} + \alpha^{10} + \alpha^3
                 + \alpha^2 + \alpha$
  $v_3$      $\alpha^{12} + \alpha^{10} + \alpha^9 + \alpha^5 + \alpha^4 +
                 \alpha^3 + \alpha^2 + \alpha$
  $v_4$      $\alpha^{15} + \alpha^{14} + \alpha^{10} + \alpha^8 + \alpha^7 +
                 \alpha$
  $v_5$      $\alpha^{15} + \alpha^{14} + \alpha^{13} + \alpha^{11} +
                 \alpha^{10} + \alpha^8 + \alpha^5 + \alpha^3 + \alpha^2 + \alpha$
  $v_6$      $\alpha^{15} + \alpha^{12} + \alpha^8 + \alpha^6 + \alpha^3 +
                 \alpha^2$
  $v_7$      $\alpha^{14} + \alpha^4 + \alpha$
  $v_8$      $\alpha^{14} + \alpha^{13} + \alpha^{11} + \alpha^{10} + \alpha^7
                 + \alpha^4 + \alpha^3$
  $v_9$      $\alpha^{12} + \alpha^7 + \alpha^6 + \alpha^4 + \alpha^3$
  $v_{10}$   $\alpha^{14} + \alpha^{13} + \alpha^{11} + \alpha^9 + \alpha^6
                 + \alpha^5 + \alpha^4 + \alpha$
  $v_{11}$   $\alpha^{15} + \alpha^{13} + \alpha^{12} + \alpha^{11} + \alpha^8$
  $v_{12}$   $\alpha^{15} + \alpha^{14} + \alpha^{13} + \alpha^{12} + \alpha^{11} + \alpha^{10} + \alpha^8 + \alpha^7 + \alpha^5 + \alpha^4 + \alpha^3$
  $v_{13}$   $\alpha^{15} + \alpha^{14} + \alpha^{13} + \alpha^{12} +
                 \alpha^{11} + \alpha^9 + \alpha^8 + \alpha^5 + \alpha^4 + \alpha^2$
  $v_{14}$   $\alpha^{15} + \alpha^{14} + \alpha^{13} + \alpha^{12} +
                 \alpha^{11} + \alpha^{10} + \alpha^9 + \alpha^8 + \alpha^5 + \alpha^4 +
                 \alpha^3$
  $v_{15}$   $\alpha^{15} + \alpha^{12} + \alpha^{11} + \alpha^8 + \alpha^4
                 + \alpha^3 + \alpha^2 + \alpha$
  ---------- --------------------------------------------------------------------------------------------------------------------------------------------
:::

Every message word $m_i=m_{i, 15} \ldots m_{i, 0}$ consists of 16 bits. As such it could be regarded as binary vector of length 16: $$m_i = (m_{i, 0} \ldots m_{i, 15})$$

Where $m_{i, 0}$ is the least significant bit of message word $m_i$. Accordingly we consider the field element $\tilde{m}_i = \sum^{15}_{j = 0} m_{i, j} v_j$ to represent that message word.

Similarly, we assign a unique index to each validator between 0 and 1,022 and we represent validator $i$ with the field element: $$\tilde{i} = \sum^{15}_{j = 0} i_j v_j$$

where $i = i_{15} \ldots i_0$ is the binary representation of $i$.

## H.3 The Generator Polynomial {#the-generator-polynomial}

To erasure code a message of 342 words into 1023 code words, we represent each message as a field element as described in previous section and we interpolate the polynomial $p(y)$ of maximum 341 degree which satisfies the following equalities: $$\begin{array}{l}
     p (\tilde{0}) = \widetilde{m_0}\\
     p (\tilde{1}) = \widetilde{m_1}\\
     \vdots\\
     p (\widetilde{341}) = \widetilde{m_{341}}
   \end{array}$$

After finding $p(y)$ with such properties, we evaluate $p$ at the following points: $$\begin{array}{l}
     \widetilde{r_{342}} : = p (\widetilde{342})\\
     \widetilde{r_{343}} : = p (\widetilde{343})\\
     \vdots\\
     \widetilde{r_{1022}} : = p (\widetilde{1022})
   \end{array}$$

We then distribute the message words and the extra code words among the validators according to their corresponding indices.

# I Index of Notation {#sec:definitions}

## I.1 Sets {#sets}

### I.1.1 Regular Notation {#regular-notation}

$\N$

:   The set of non-negative integers. Subscript denotes one greater than the maximum. See section [3.4](#sec:numbers){reference-type="ref" reference="sec:numbers"}.

    $\N^+$

    :   The set of positive integers (not including zero).

    $\N_B$

    :   The set of balance values. Equivalent to $\N_{2^{64}}$. See equation [\[eq:balance\]](#eq:balance){reference-type="ref" reference="eq:balance"}.

    $\N_G$

    :   The set of unsigned gas values. Equivalent to $\mathbb{N}_{2^{64}}$. See equation [\[eq:gasregentry\]](#eq:gasregentry){reference-type="ref" reference="eq:gasregentry"}.

    $\N_L$

    :   The set of blob length values. Equivalent to $\N_{2^{32}}$. See section [3.4](#sec:numbers){reference-type="ref" reference="sec:numbers"}.

    $\N_S$

    :   The set from which service indices are drawn. Equivalent to $\N_{2^{32}}$. See section [\[eq:serviceaccounts\]](#eq:serviceaccounts){reference-type="ref" reference="eq:serviceaccounts"}.

    $\N_T$

    :   The set of timeslot values. Equivalent to $\N_{2^{32}}$. See equation [\[eq:time\]](#eq:time){reference-type="ref" reference="eq:time"}.

$\mathbb{Q}$

:   The set of rational numbers. Unused.

$\mathbb{R}$

:   The set of real numbers. Unused.

$\mathbb{Z}$

:   The set of integers. Subscript denotes range. See section [3.4](#sec:numbers){reference-type="ref" reference="sec:numbers"}.

    $\Z_G$

    :   The set of signed gas values. Equivalent to $\mathbb{Z}_{-2^{63}\dots2^{63}}$. See equation [\[eq:gasregentry\]](#eq:gasregentry){reference-type="ref" reference="eq:gasregentry"}.

### I.1.2 Custom Notation {#custom-notation}

$\mathbb{A}$

:   The set of service accounts. See equation [\[eq:serviceaccount\]](#eq:serviceaccount){reference-type="ref" reference="eq:serviceaccount"}.

$\mathbb{B}$

:   The set of Boolean sequences/bitstrings. Subscript denotes length. See section [3.7](#sec:sequences){reference-type="ref" reference="sec:sequences"}.

$\mathbb{C}$

:   The set of seal-key tickets. See equation [\[eq:ticket\]](#eq:ticket){reference-type="ref" reference="eq:ticket"}. *Not used as the set of complex numbers.*

$\mathbb{D}$

:   The set of dictionaries. See section [3.5](#sec:dictionaries){reference-type="ref" reference="sec:dictionaries"}.

    $\dict{K}{V}$

    :   The set of dictionaries making a partial bijection of domain $K$ to range $V$. See section [3.5](#sec:dictionaries){reference-type="ref" reference="sec:dictionaries"}.

$\mathbb{E}$

:   The set of valid Ed25519 signatures. A subset of $\Y_{64}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

    $\sig{K}{M}$

    :   The set of valid Ed25519 signatures of the key $K$ and message $M$. A subset of $\mathbb{E}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

$\mathbb{F}$

:   The set of Bandersnatch signatures. A subset of $\Y_{64}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}. *NOTE: Not used as finite fields.*

    $\bandersig{K}{C}{M}$

    :   The set of Bandersnatch signatures of the public key $K$, context $C$ and message $M$. A subset of $\mathbb{F}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

    $\bar{\mathbb{F}}$

    :   The set of Bandersnatch Ring[vrf]{.smallcaps} proofs. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

    $\bandersnatch{R}{C}{M}$

    :   The set of Bandersnatch Ring[vrf]{.smallcaps} proofs of the root $R$, context $C$ and message $M$. A subset of $\bar{\mathbb{F}}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

$\mathbb{G}$

:   The set of data segments, equivalent to octet sequences of length $\mathsf{W}_S$. See equation [\[eq:segment\]](#eq:segment){reference-type="ref" reference="eq:segment"}.

$\H$

:   The set of 32-octet cryptographic values. A subset of $\Y_{32}$. $\H$ without a subscript generally implies a hash function result. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}. *NOTE: Not used as quaternions.*

    $\H_B$

    :   The set of Bandersnatch public keys. A subset of $\Y_{32}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"} and appendix [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"}.

    $\H_E$

    :   The set of Ed25519 public keys. A subset of $\Y_{32}$. See section [3.8.2](#sec:signing){reference-type="ref" reference="sec:signing"}.

$\mathbb{I}$

:   The set of work items. See equation [\[eq:workitem\]](#eq:workitem){reference-type="ref" reference="eq:workitem"}.

$\mathbb{J}$

:   The set of work execution errors.

$\mathbb{K}$

:   The set of validator key-sets. See equation [\[eq:validatorkeys\]](#eq:validatorkeys){reference-type="ref" reference="eq:validatorkeys"}.

$\mathbb{L}$

:   The set of work results.

$\mathbb{M}$

:   The set of [pvm]{.smallcaps} [ram]{.smallcaps} states. A superset of $\Y_{2^{32}}$. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

$\mathbb{O}$

:   The accumulation operand element, corresponding to a single work result.

$\mathbb{P}$

:   The set of work-packages. See equation [\[eq:workpackage\]](#eq:workpackage){reference-type="ref" reference="eq:workpackage"}.

$\mathbb{S}$

:   The set of availability specifications.

$\mathbb{T}$

:   The set of deferred transfers.

$\mathbb{U}$

:   Unused.

$\mathbb{V}_{\mu}$

:   The set of validly readable indices for [pvm]{.smallcaps} [ram]{.smallcaps} $\mu$. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

$\mathbb{V}^*_{\mu}$

:   The set of validly writable indices for [pvm]{.smallcaps} [ram]{.smallcaps} $\mu$. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

$\mathbb{W}$

:   The set of work-reports.

$\mathbb{X}$

:   The set of refinement contexts.

$\Y$

:   The set of octet strings/"blobs". Subscript denotes length. See section [3.7](#sec:sequences){reference-type="ref" reference="sec:sequences"}.

    $\Y_{BLS}$

    :   The set of BLS public keys. A subset of $\Y_{144}$. See section [3.8.2](#sec:signing){reference-type="ref" reference="sec:signing"}.

    $\Y_R$

    :   The set of Bandersnatch ring roots. A subset of $\Y_{144}$. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"} and appendix [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"}.

## I.2 Functions {#functions}

$\Lambda$

:   The historical lookup function. See equation [\[eq:historicallookup\]](#eq:historicallookup){reference-type="ref" reference="eq:historicallookup"}.

$\Xi$

:   The work result computation function. See equation [\[eq:workresultfunction\]](#eq:workresultfunction){reference-type="ref" reference="eq:workresultfunction"}.

$\Upsilon$

:   The general state transition function. See equations [\[eq:statetransition\]](#eq:statetransition){reference-type="ref" reference="eq:statetransition"}, [\[eq:transitionfunctioncomposition\]](#eq:transitionfunctioncomposition){reference-type="ref" reference="eq:transitionfunctioncomposition"}.

$\Phi$

:   The key-nullifier function. See equation [\[eq:blacklistfilter\]](#eq:blacklistfilter){reference-type="ref" reference="eq:blacklistfilter"}.

$\Psi$

:   The whole-program [pvm]{.smallcaps} machine state-transition function. See equation [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

    $\Psi_1$

    :   The single-step ([pvm]{.smallcaps}) machine state-transition function. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

    $\Psi_A$

    :   The Accumulate [pvm]{.smallcaps} invocation function. See appendix [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}.

    $\Psi_H$

    :   The host-function invocation ([pvm]{.smallcaps}) with host-function marshalling. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

    $\Psi_I$

    :   The Is-Authorized [pvm]{.smallcaps} invocation function. See appendix [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}.

    $\Psi_M$

    :   The marshalling whole-program [pvm]{.smallcaps} machine state-transition function. See appendix [24](#sec:virtualmachine){reference-type="ref" reference="sec:virtualmachine"}.

    $\Psi_R$

    :   The Refine [pvm]{.smallcaps} invocation function. See appendix [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}.

    $\Psi_T$

    :   The On-Transfer [pvm]{.smallcaps} invocation function. See appendix [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}.

$\Omega$

:   Virtual machine host-call functions. See appendix [25](#sec:virtualmachineinvocations){reference-type="ref" reference="sec:virtualmachineinvocations"}.

    $\Omega_A$

    :   Assign-core host-call.

    $\Omega_C$

    :   Checkpoint host-call.

    $\Omega_D$

    :   Designate-validators host-call.

    $\Omega_E$

    :   Empower-service host-call.

    $\Omega_F$

    :   Forget-preimage host-call.

    $\Omega_G$

    :   Gas-remaining host-call.

    $\Omega_H$

    :   Historical-lookup-preimage host-call.

    $\Omega_I$

    :   Information-on-service host-call.

    $\Omega_K$

    :   Kickoff-[pvm]{.smallcaps} host-call.

    $\Omega_L$

    :   Lookup-preimage host-call.

    $\Omega_M$

    :   Make-[pvm]{.smallcaps} host-call.

    $\Omega_N$

    :   New-service host-call.

    $\Omega_O$

    :   Poke-[pvm]{.smallcaps} host-call.

    $\Omega_P$

    :   Peek-[pvm]{.smallcaps} host-call.

    $\Omega_Q$

    :   Quit-service host-call.

    $\Omega_S$

    :   Solicit-preimage host-call.

    $\Omega_R$

    :   Read-storage host-call.

    $\Omega_T$

    :   Transfer host-call.

    $\Omega_U$

    :   Upgrade-service host-call.

    $\Omega_W$

    :   Write-storage host-call.

    $\Omega_X$

    :   Expunge-[pvm]{.smallcaps} host-call.

    $\Omega_Y$

    :   Import segment host-call.

    $\Omega_Z$

    :   Export segment host-call.

## I.3 Utilities, Externalities and Standard Functions {#utilities-externalities-and-standard-functions}

$\mathcal{A}(\dots)$

:   The Merkle mountain range append function. See equation [\[eq:mmrappend\]](#eq:mmrappend){reference-type="ref" reference="eq:mmrappend"}.

$\mathcal{B}_n(\dots)$

:   The octets-to-bits function for $n$ octets. Superscripted ${}^{-1}$ to denote the inverse. See equation [\[eq:bitsfunc\]](#eq:bitsfunc){reference-type="ref" reference="eq:bitsfunc"}.

$\mathcal{C}(\dots)$

:   The group of erasure-coding functions.

$\mathcal{C}_n(\dots)$

:   The erasure-coding functions for $n$ chunks. See equation [\[eq:erasurecoding\]](#eq:erasurecoding){reference-type="ref" reference="eq:erasurecoding"}.

$\se(\dots)$

:   The octet-sequence encode function. Superscripted ${}^{-1}$ to denote the inverse. See appendix [26](#sec:serialization){reference-type="ref" reference="sec:serialization"}.

$\mathcal{F}(\dots)$

:   The Fisher-Yates shuffle function. See equation [\[eq:suffle\]](#eq:suffle){reference-type="ref" reference="eq:suffle"}.

$\mathcal{H}(\dots)$

:   The Blake 2b 256-bit hash function. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

$\mathcal{H}_K(\dots)$

:   The Keccak 256-bit hash function. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

$\mathcal{K}(\dots)$

:   The domain, or set of keys, of a dictionary. See section [3.5](#sec:dictionaries){reference-type="ref" reference="sec:dictionaries"}.

$\mathcal{M}(\dots)$

:   The constant-depth binary Merklization function. See appendix [28](#sec:merklization){reference-type="ref" reference="sec:merklization"}.

$\mathcal{M}_B(\dots)$

:   The well-balanced binary Merklization function. See appendix [28](#sec:merklization){reference-type="ref" reference="sec:merklization"}.

$\mathcal{M}_\sigma(\dots)$

:   The state Merklization function. See appendix [27](#sec:statemerklization){reference-type="ref" reference="sec:statemerklization"}.

$\mathcal{N}(\dots)$

:   The erasure-coding chunks function. See appendix [31](#sec:erasurecoding){reference-type="ref" reference="sec:erasurecoding"}.

$\mathcal{O}(\dots)$

:   The Bandersnatch ring root function. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"} and appendix [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"}.

$\mathcal{P}_n(\dots)$

:   The octet-array zero-padding function. See equation [\[eq:zeropadding\]](#eq:zeropadding){reference-type="ref" reference="eq:zeropadding"}.

$\mathcal{Q}(\dots)$

:   The numeric-sequence-from-hash function. See equation [\[eq:sequencefromhash\]](#eq:sequencefromhash){reference-type="ref" reference="eq:sequencefromhash"}.

$\mathcal{R}$

:   The group of erasure-coding piece-recovery functions.

$\mathcal{S}_k(\dots)$

:   The general signature function. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"}.

$\mathcal{T}$

:   The current time expressed in seconds after the start of the JAM Common Era. See section [4.4](#sec:commonera){reference-type="ref" reference="sec:commonera"}.

$\mathcal{U}(\dots)$

:   The substitute-if-nothing function. See equation [\[eq:substituteifnothing\]](#eq:substituteifnothing){reference-type="ref" reference="eq:substituteifnothing"}.

$\mathcal{V}(\dots)$

:   The range, or set of values, of a dictionary or sequence. See section [3.5](#sec:dictionaries){reference-type="ref" reference="sec:dictionaries"}.

$\mathcal{X}_n(\dots)$

:   The signed-extension function for a value in $\N_{2^{8n}}$. See equation [\[eq:signedextension\]](#eq:signedextension){reference-type="ref" reference="eq:signedextension"}.

$\mathcal{Y}(\dots)$

:   The alias/output/entropy function of a Bandersnatch [vrf]{.smallcaps} signature/proof. See section [3.8](#sec:cryptography){reference-type="ref" reference="sec:cryptography"} and appendix [30](#sec:bandersnatch){reference-type="ref" reference="sec:bandersnatch"}.

$\mathcal{Z}_n(\dots)$

:   The into-signed function for a value in $\N_{2^{8n}}$. Superscripted with ${}^{-1}$ to denote the inverse. See equation [\[eq:signedfunc\]](#eq:signedfunc){reference-type="ref" reference="eq:signedfunc"}.

$\powset{\dots}$

:   Power set function.

## I.4 Values {#values}

### I.4.1 Block-context Terms {#block-context-terms}

These terms are all contextualized to a single block. They may be superscripted with some other term to alter the context and reference some other block.

$\mathbf{A}$

:   The ancestor set of the block. See equation [\[eq:ancestors\]](#eq:ancestors){reference-type="ref" reference="eq:ancestors"}.

$\mathbf{B}$

:   The block. See equation [\[eq:block\]](#eq:block){reference-type="ref" reference="eq:block"}.

$\mathbf{C}$

:   The service accumulation-commitment, used to form the [Beefy]{.smallcaps} root. See equation [\[eq:beefycommitment\]](#eq:beefycommitment){reference-type="ref" reference="eq:beefycommitment"}.

$\mathbf{E}$

:   The block extrinsic. See equation [\[eq:extrinsic\]](#eq:extrinsic){reference-type="ref" reference="eq:extrinsic"}.

$\mathbf{F}_v$

:   The [Beefy]{.smallcaps} signed commitment of validator $v$. See equation [\[eq:beefysignedcommitment\]](#eq:beefysignedcommitment){reference-type="ref" reference="eq:beefysignedcommitment"}.

$\mathbf{G}$

:   The mapping from cores to guarantor keys. See section [11.3](#sec:coresandvalidators){reference-type="ref" reference="sec:coresandvalidators"}.

$\mathbf{G^*}$

:   The mapping from cores to guarantor keys for the previous rotation. See section [11.3](#sec:coresandvalidators){reference-type="ref" reference="sec:coresandvalidators"}.

$\mathbf{H}$

:   The block header. See equation [\[eq:header\]](#eq:header){reference-type="ref" reference="eq:header"}.

$\mathbf{Q}$

:   The selection of ready work-reports which a validator determined they must audit. See equation [\[eq:auditselection\]](#eq:auditselection){reference-type="ref" reference="eq:auditselection"}.

$\mathbf{R}$

:   The set of Ed25519 guarantor keys who made a work-report. See equation [\[eq:guarantorsig\]](#eq:guarantorsig){reference-type="ref" reference="eq:guarantorsig"}.

$\mathbf{S}$

:   The set of indices of services which have been accumulated ("progressed") in the block. See equation [\[eq:servicestoaccumulate\]](#eq:servicestoaccumulate){reference-type="ref" reference="eq:servicestoaccumulate"}.

$\mathbf{T}$

:   The ticketed condition, true if the block was sealed with a ticket signature rather than a fallback. See equations [\[eq:ticketconditiontrue\]](#eq:ticketconditiontrue){reference-type="ref" reference="eq:ticketconditiontrue"} and [\[eq:ticketconditionfalse\]](#eq:ticketconditionfalse){reference-type="ref" reference="eq:ticketconditionfalse"}.

$\mathbf{U}$

:   The audit condition, equal to $\top$ once the block is audited. See section [17](#sec:auditing){reference-type="ref" reference="sec:auditing"}.

$\mathbf{W}$

:   The set of work-reports which have now become available and ready for accumulation. See equation [\[eq:availableworkreports\]](#eq:availableworkreports){reference-type="ref" reference="eq:availableworkreports"}.

Without any superscript, the block is assumed to the block being imported or, if no block is being imported, the head of the best chain (see section [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}). Explicit block-contextualizing superscripts include:

$\mathbf{B}^\natural$

:   The latest finalized block. See equation [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}.

$\mathbf{B}^\flat$

:   The block at the head of the best chain. See equation [19](#sec:bestchain){reference-type="ref" reference="sec:bestchain"}.

### I.4.2 State components {#state-components}

Here, the prime annotation indicates posterior state. Individual components may be identified with a letter subscript.

$\alpha$

:   The core $\alpha$uthorizations pool. See equation [\[eq:authstatecomposition\]](#eq:authstatecomposition){reference-type="ref" reference="eq:authstatecomposition"}.

$\beta$

:   Information on the most recent $\beta$locks.

$\gamma$

:   State concerning Safrole. See equation [\[eq:consensusstatecomposition\]](#eq:consensusstatecomposition){reference-type="ref" reference="eq:consensusstatecomposition"}.

    $\gamma_\mathbf{a}$

    :   The sealing lottery ticket accumulator.

    $\gamma_\mathbf{k}$

    :   The keys for the validators of the next epoch, equivalent to those keys which constitute $\gamma_z$.

    $\gamma_\mathbf{s}$

    :   The sealing-key sequence of the current epoch.

    $\gamma_z$

    :   The Bandersnatch root for the current epoch's ticket submissions.

$\delta$

:   The (prior) state of the service accounts.

    $\delta^\dagger$

    :   The post-preimage integration, pre-accumulation intermediate state.

    $\delta^\ddagger$

    :   The post-accumulation, pre-transfer intermediate state.

$\eta$

:   The e$\eta$tropy accumulator and epochal ra$\eta$domness.

$\iota$

:   The validator keys and metadata to be drawn from next.

$\kappa$

:   The validator $\kappa$eys and metadata currently active.

$\lambda$

:   The validator keys and metadata which were active in the prior epoch.

$\rho$

:   The $\rho$ending reports, per core, which are being made available prior to accumulation.

    $\rho^\dagger$

    :   The post-judgement, pre-guarantees-extrinsic intermediate state.

    $\rho^\ddagger$

    :   The post-guarantees-extrinsic, pre-assurances-extrinsic, intermediate state.

$\sigma$

:   The $\sigma$verall state of the system. See equations [\[eq:statetransition\]](#eq:statetransition){reference-type="ref" reference="eq:statetransition"}, [\[eq:statecomposition\]](#eq:statecomposition){reference-type="ref" reference="eq:statecomposition"}.

$\tau$

:   The most recent block's $\tau$imeslot.

$\varphi$

:   The authorization queue.

$\psi$

:   Past judgements on work-reports and validators.

    $\badset$

    :   Work-reports judged to be incorrect.

    $\goodset$

    :   Work-reports judged to be correct.

    $\wonkyset$

    :   Work-reports whose validity is judged to be unknowable.

    $\offenders$

    :   Validators who made a judgement found to be incorrect.

$\chi$

:   The privileged service indices.

    $\chi_m$

    :   The index of the empower service.

    $\chi_v$

    :   The index of the designate service.

    $\chi_a$

    :   The index of the assign service.

$\pi$

:   The activity statistics for the validators.

### I.4.3 Virtual Machine components {#virtual-machine-components}

$\varepsilon$

:   The exit-reason resulting from all machine state transitions.

$\nu$

:   The immediate values of an instruction.

$\mu$

:   The memory sequence; a member of the set $\mathbb{M}$.

$\xi$

:   The gas counter.

$\omega$

:   The registers.

$\zeta$

:   The instruction sequence.

$\varpi$

:   The sequence of basic blocks of the program.

$\imath$

:   The instruction counter.

### I.4.4 Constants {#constants}

$\mathsf{A} = 8$

:   The period, in seconds, between audit tranches.

$\mathsf{B}_I = 10$

:   The additional minimum balance required per item of elective service state.

$\mathsf{B}_L = 1$

:   The additional minimum balance required per octet of elective service state.

$\mathsf{B}_S = 100$

:   The basic minimum balance which all services require.

$\mathsf{C} = 341$

:   The total number of cores.

$\mathsf{D} = 28,800$

:   The period in timeslots after which an unreferenced preimage may be expunged.

$\mathsf{E} = 600$

:   The length of an epoch in timeslots.

$\mathsf{F} = 2$

:   The audit bias factor, the expected number of additional validators who will audit a work-report in the following tranche for each no-show in the previous.

$\mathsf{G}_A$

:   The total gas allocated to a core for Accumulation.

$\mathsf{G}_I$

:   The gas allocated to invoke a work-package's Is-Authorized logic.

$\mathsf{G}_R$

:   The total gas allocated for a work-package's Refine logic.

$\mathsf{H} = 8$

:   The size of recent history, in blocks.

$\mathsf{I} = 4$

:   The maximum amount of work items in a package.

$\mathsf{K} = 16$

:   The maximum number of tickets which may be submitted in a single extrinsic.

$\mathsf{L} = 14,400$

:   The maximum age in timeslots of the lookup anchor.

$\mathsf{M} = 128$

:   The size of a transfer memo in octets.

$\mathsf{N} = 2$

:   The number of ticket entries per validator.

$\mathsf{O} = 8$

:   The maximum number of items in the authorizations pool.

$\mathsf{P} = 6$

:   The slot period, in seconds.

$\mathsf{Q} = 80$

:   The maximum number of items in the authorizations queue.

$\mathsf{R} = 10$

:   The rotation period of validator-core assignments, in timeslots.

$\mathsf{S} = 4,000,000$

:   The maximum size of service code in octets.

$\mathsf{U} = 5$

:   The period in timeslots after which reported but unavailable work may be replaced.

$\mathsf{V} = 1023$

:   The total number of validators.

$\mathsf{W}_C = 684$

:   The basic size of our erasure-coded pieces. See equation [\[eq:erasurecoding\]](#eq:erasurecoding){reference-type="ref" reference="eq:erasurecoding"}.

$\mathsf{W}_M = 2^{11}$

:   The maximum number of entries in a work-package manifest.

$\mathsf{W}_P = 12\cdot2^{20}$

:   The maximum size of an encoded work-package together with its extrinsic data and import implications, in octets.

$\mathsf{W}_R = 96\cdot2^{10}$

:   The maximum size of an encoded work-report in octets.

$\mathsf{W}_S = 6$

:   The size of an exported segment in erasure-coded pieces.

$\mathsf{X}$

:   Context strings, see below.

$\mathsf{Y} = 500$

:   The number of slots into an epoch at which ticket-submission ends.

$\mathsf{Z}_A = 2$

:   The [pvm]{.smallcaps} dynamic address alignment factor. See equation [\[eq:jumptablealignment\]](#eq:jumptablealignment){reference-type="ref" reference="eq:jumptablealignment"}.

$\mathsf{Z}_I = 2^{24}$

:   The standard [pvm]{.smallcaps} program initialization input data size. See equation [24.7](#sec:standardprograminit){reference-type="ref" reference="sec:standardprograminit"}.

$\mathsf{Z}_P = 2^{14}$

:   The standard [pvm]{.smallcaps} program initialization page size. See section [24.7](#sec:standardprograminit){reference-type="ref" reference="sec:standardprograminit"}.

$\mathsf{Z}_Q = 2^{16}$

:   The standard [pvm]{.smallcaps} program initialization segment size. See section [24.7](#sec:standardprograminit){reference-type="ref" reference="sec:standardprograminit"}.

### I.4.5 Signing Contexts {#signing-contexts}

$\mathsf{X}_A = \token{\$jam\_available}$

:   *Ed25519* Availability assurances.

$\mathsf{X}_B = \token{\$jam\_beefy}$

:   *[bls]{.smallcaps}* Accumulate-result-root-[mmr]{.smallcaps} commitment.

$\mathsf{X}_E = \token{\$jam\_entropy}$

:   On-chain entropy generation.

$\mathsf{X}_F = \token{\$jam\_fallback\_seal}$

:   *Bandersnatch* Fallback block seal.

$\mathsf{X}_G = \token{\$jam\_guarantee}$

:   *Ed25519* Guarantee statements.

$\mathsf{X}_I = \token{\$jam\_announce}$

:   *Ed25519* Audit announcement statements.

$\mathsf{X}_T = \token{\$jam\_ticket\_seal}$

:   *Bandersnatch Ring[vrf]{.smallcaps}* Ticket generation and regular block seal.

$\mathsf{X}_U = \token{\$jam\_audit}$

:   *Bandersnatch* Audit selection entropy.

$\mathsf{X}_\top = \token{\$jam\_valid}$

:   *Ed25519* Judgements for valid work-reports.

$\mathsf{X}_\bot = \token{\$jam\_invalid}$

:   *Ed25519* Judgements for invalid work-reports.

[^1]: The gas mechanism did restrict what programs can execute on it by placing an upper bound on the number of steps which may be executed, but some restriction to avoid infinite-computation must surely be introduced in a permissionless setting.

[^2]: Practical matters do limit the level of real decentralization. Validator software expressly provides functionality to allow a single instance to be configured with multiple key sets, systematically facilitating a much lower level of actual decentralization than the apparent number of actors, both in terms of individual operators and hardware. Using data collated by [@hildobby2024eth2] on Ethereum 2, one can see one major node operator, Lido, has steadily accounted for almost one-third of the almost one million crypto-economic participants.

[^3]: Ethereum's developers hope to change this to something more secure, but no timeline is fixed.

[^4]: Some initial thoughts on the matter resulted in a proposal by [@sadana2024bringing] to utilize Polkadot technology as a means of helping create a modicum of compatibility between roll-up ecosystems!

[^5]: In all likelihood actually substantially more as this was using low-tier "spare" hardware in consumer units, and our recompiler was unoptimized.

[^6]: Earlier node versions utilized Arweave network, a decentralized data store, but this was found to be unreliable for the data throughput which Solana required.

[^7]: Practically speaking, blockchains sometimes make assumptions of some fraction of participants whose behavior is simply *honest*, and not provably incorrect nor otherwise economically disincentivized. While the assumption may be reasonable, it must nevertheless be stated apart from the rules of state-transition.

[^8]: 1,704,110,400 seconds after the Unix Epoch.

[^9]: This is three fewer than [risc-v]{.smallcaps}'s 16, however the amount that program code output by compilers uses is 13 since two are reserved for operating system use and the third is fixed as zero

[^10]: Technically there is some small assumption of state, namely that some modestly recent instance of each service's preimages. The specifics of this are discussed in section [14.3](#sec:packagesanditems){reference-type="ref" reference="sec:packagesanditems"}.

[^11]: This requirement may seem somewhat arbitrary, but these happen to be the decision thresholds for our three possible actions and are acceptable since the security assumptions include the requirement that at least two-thirds-plus-one validators are live ([@cryptoeprint:2024/961] discusses the security implications in depth).

[^12]: This is a "soft" implication since there is no consequence on-chain if dishonestly reported. For more information on this implication see section [16](#sec:assurance){reference-type="ref" reference="sec:assurance"}.

[^13]: The latest "proto-danksharding" changes allow it to accept 87.3[kb]{.smallcaps}/s in committed-to data though this is not directly available within state, so we exclude it from this illustration, though including it with the input data would change the results little.

[^14]: This is detailed at [{https://hackmd.io/@XXX9CM1uSSCWVNFRYaSB5g/HJarTUhJA}]({https://hackmd.io/@XXX9CM1uSSCWVNFRYaSB5g/HJarTUhJA}){.uri} and intended to be updated as we get more information.

[^15]: It is conservative since we don't take into account that the source code was originally compiled into [evm]{.smallcaps} code and thus the [pvm]{.smallcaps} machine code will replicate architectural artifacts and thus is very likely to be pessimistic. As an example, all arithmetic operations in [evm]{.smallcaps} are 256-bit and 32-bit native [pvm]{.smallcaps} is being forced to honor this even if the source code only actually required 32-bit values.

[^16]: We speculate that the substantial range could possibly be caused in part by the major architectural differences between the [evm]{.smallcaps} [isa]{.smallcaps} typical modern hardware.

[^17]: As an example, our odd-product benchmark, a very much pure-compute arithmetic task, execution takes 58s on [evm]{.smallcaps}, and 1.04s within our [pvm]{.smallcaps} prototype, including all preprocessing.

[^18]: The popular code generation backend [llvm]{.smallcaps} requires and assumes in its code generation that dynamically computed jump destinations always have a certain memory alignment. Since at present we depend on this for our tooling, we must acquiesce to its assumptions.

[^19]: Note that since specific values may belong to both sets which would need a discriminator and those that would not then we are sadly unable to introduce a function capable of serializing corresponding to the *term*'s limitation. A more sophisticated formalism than basic set-theory would be needed, capable of taking into account not simply the value but the term from which or to which it belongs in order to do this succinctly.
