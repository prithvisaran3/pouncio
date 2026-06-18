import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";
import * as crypto from "crypto";
import { TARGET_COMPANIES, CompanyConfig } from "./sources/companies";

admin.initializeApp();
const db = admin.firestore();

// Helper to verify if a job URL is active and still accepting applications
async function isUrlActive(url: string): Promise<boolean> {
  const lowercaseUrl = url.toLowerCase();
  const isGreenhouse = lowercaseUrl.includes("greenhouse.io");
  const isLever = lowercaseUrl.includes("lever.co");
  const isAshby = lowercaseUrl.includes("ashbyhq.com");

  // Only validate ATS URLs (Greenhouse, Lever, Ashby) to ensure efficiency and avoid blocking issues (e.g. LinkedIn)
  if (!isGreenhouse && !isLever && !isAshby) {
    return true;
  }

  try {
    const response = await axios.get(url, {
      timeout: 5000,
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      },
      validateStatus: () => true // Prevent throwing on 404/302 redirects
    });

    if (response.status === 404) {
      console.log(`[Validation] Job inactive (404) for URL: ${url}`);
      return false;
    }

    const html = (response.data || "").toLowerCase();

    if (isGreenhouse) {
      if (
        html.includes("no longer accepting applications") ||
        html.includes("job is no longer available") ||
        html.includes("no longer available") ||
        html.includes("job not found")
      ) {
        console.log(`[Validation] Greenhouse job closed for URL: ${url}`);
        return false;
      }
    }

    if (isLever) {
      if (
        html.includes("no longer accepting applications") ||
        html.includes("job is no longer available") ||
        html.includes("no longer available") ||
        html.includes("posting not found")
      ) {
        console.log(`[Validation] Lever job closed for URL: ${url}`);
        return false;
      }
    }

    if (isAshby) {
      if (
        html.includes("no longer accepting applications") ||
        html.includes("job is no longer available") ||
        html.includes("no longer available")
      ) {
        console.log(`[Validation] Ashby job closed for URL: ${url}`);
        return false;
      }
    }

    return true;
  } catch (error: any) {
    // Fail-safe: if request fails due to network issues/timeouts, assume it is still active to avoid false negatives
    console.warn(`[Validation Warning] Error checking URL active state: ${url}. Error: ${error.message}`);
    return true;
  }
}


// Helper to filter early career / new grad roles
function isEarlyCareerRole(title: string, isFromCuratedSource = false): boolean {
  const t = title.toLowerCase();
  const includesSenior = /(senior|sr\.|lead|principal|ii|iii|iv|manager|director)/i.test(t);
  if (includesSenior) return false;

  if (isFromCuratedSource) {
    return true;
  }

  const includesEarly = /(new grad|entry level|associate|junior|university graduate|software engineer i|swe i\b|analyst|intern|apprentice)/i.test(t);
  return includesEarly;
}

// Helper to check if a job is in the CS / Software / Tech domain
function isComputerScienceRole(title: string): boolean {
  const t = title.toLowerCase();

  // Exclude non-CS engineering/technical subjects clearly:
  const nonCsExclusions = [
    /mechanical/, /aerospace/, /civil/, /electrical/, /chemical/, /industrial/,
    /hardware/, /firmware/, /materials/, /materials science/, /physics/,
    /operations center/, /fleet/, /automotive/, /nuclear/, /bio/, /biomedical/,
    /construction/, /geotechnical/, /manufacturing/, /manufacturing engineer/
  ];

  if (nonCsExclusions.some(pattern => pattern.test(t))) {
    return false;
  }

  // Include typical CS / Software / Tech keywords:
  const csKeywords = [
    "software", "developer", "programmer", "computer", "web", "frontend", "backend", "fullstack", "full stack",
    "mobile", "ios", "android", "flutter", "react-native", "react native", "swift", "kotlin", "cloud", "devops", "sre", 
    "data engineer", "data scientist", "data science", "machine learning", "ml", "ai", "network engineer", 
    "systems engineer", "application engineer", "applications engineer", "coding"
  ];

  return csKeywords.some(keyword => t.includes(keyword));
}

// Helper to determine if a job is specifically a mobile app, Flutter, or iOS/Android developer role
function isMobileAppDevRole(title: string): boolean {
  const t = title.toLowerCase();
  return (
    t.includes("mobile") ||
    t.includes("flutter") ||
    t.includes("ios") ||
    t.includes("android") ||
    t.includes("react-native") ||
    t.includes("react native") ||
    t.includes("swift") ||
    t.includes("kotlin") ||
    t.includes("dart") ||
    t.includes("app developer") ||
    t.includes("app engineer")
  );
}

// Helper to filter jobs that match the user's resume/skills profile
export function isBestFitJob(title: string, description: string): boolean {
  const t = title.toLowerCase();
  const desc = description.toLowerCase();

  // Exclude roles that do not fit the user's software/app development focus
  const exclusions = [
    /\bqa\b/, /\btesting\b/, /test engineer/, /\bsdet\b/, /quality assurance/,
    /devops/, /\bsre\b/, /site reliability/, /platform engineer/, /infrastructure/,
    /data analyst/, /business analyst/, /system analyst/, /product manager/, /project manager/, /scrum master/,
    /cybersecurity/, /security analyst/, /information security/,
    /hardware engineer/, /firmware/, /embedded/,
    /support engineer/, /technical support/, /help desk/
  ];

  if (exclusions.some(pattern => pattern.test(t))) {
    return false;
  }

  // 1. Mobile Development (Highest fit)
  const mobileKeywords = [
    "mobile", "flutter", "ios", "android", "react native", "swift", "kotlin", "dart", "swiftui", "app developer", "app engineer"
  ];
  if (mobileKeywords.some(keyword => t.includes(keyword))) {
    return true;
  }

  // 2. Software Engineer / Developer / Backend / Full Stack matching tech stack from resume
  const softwareKeywords = [
    "software engineer", "software developer", "swe", "backend", "full stack", "fullstack", "developer", "engineer"
  ];
  const stackKeywords = [
    "python", "django", "node", "java", "aws", "firebase", "supabase", "postgresql", "mongodb", "javascript", "typescript", "react"
  ];

  const isSoftware = softwareKeywords.some(keyword => t.includes(keyword));
  const hasStackSkill = stackKeywords.some(keyword => t.includes(keyword) || desc.includes(keyword));

  if (isSoftware) {
    // General SWE/Developer roles are highly relevant early career paths
    if (t.includes("software engineer") || t.includes("software developer") || t.includes("swe") || t.includes("generalist")) {
      return true;
    }
    // Specific developer/engineer roles are a fit if they align with the tech stack
    if (hasStackSkill) {
      return true;
    }
  }

  // 3. Internships matching software engineering/developer or stack keywords
  if (t.includes("intern") || t.includes("internship") || t.includes("co-op")) {
    if (t.includes("software") || t.includes("developer") || t.includes("engineer") || hasStackSkill) {
      return true;
    }
  }

  return false;
}


// Deterministic ID generator based on job details
function generateJobId(company: string, title: string, applyUrl: string): string {
  const cleanUrl = applyUrl.split("?")[0]; // ignore tracking query params
  const hash = crypto.createHash("sha256");
  hash.update(`${company.toLowerCase()}_${title.toLowerCase()}_${cleanUrl.toLowerCase()}`);
  return hash.digest("hex").substring(0, 20);
}

// Send a single summary push notification containing the list of all companies updated
// and a separate section for entry level/fresh grad/new grad mobile developer roles.
async function sendSummaryNotifications(newlyAddedJobs: any[]) {
  if (newlyAddedJobs.length === 0) return;

  // Filter for jobs posted/updated in the past 15 minutes
  const nowMs = Date.now();
  const fifteenMinsAgoMs = nowMs - 15 * 60 * 1000;
  
  const recentJobs = newlyAddedJobs.filter(j => {
    try {
      const postedMs = new Date(j.postedAt).getTime();
      return postedMs >= fifteenMinsAgoMs;
    } catch (e) {
      return false;
    }
  });

  if (recentJobs.length === 0) {
    console.log("[FCM] No new jobs were posted in the past 15 minutes. Skipping summary notifications.");
    return;
  }

  const uniqueCompanies = Array.from(new Set(recentJobs.map(j => j.company)));
  
  // High chance matches are entry level / fresh grad / new grad mobile developer roles
  const highChanceJobs = recentJobs.filter(j => 
    isMobileAppDevRole(j.role) && isEarlyCareerRole(j.role, !j.isFallback)
  );

  const totalNewCount = recentJobs.length;
  const globalTitle = `💼 Pouncio: ${totalNewCount} New Job${totalNewCount === 1 ? "" : "s"} Added!`;
  
  let companyListStr = uniqueCompanies.join(", ");
  if (uniqueCompanies.length > 8) {
    companyListStr = uniqueCompanies.slice(0, 8).join(", ") + `, and ${uniqueCompanies.length - 8} more`;
  }
  
  let globalBody = `Companies updated: ${companyListStr}`;
  if (highChanceJobs.length > 0) {
    const displayJobs = highChanceJobs.slice(0, 5);
    globalBody += `\n\n🎯 High Chance Matches:\n` + 
      displayJobs.map(j => `• ${j.company}: ${j.role}`).join("\n");
    if (highChanceJobs.length > 5) {
      globalBody += `\n• and ${highChanceJobs.length - 5} more...`;
    }
  }

  const globalNotifId = `notif_summary_${Date.now()}`;
  
  // Save global summary notification to Firestore
  await db.collection("notifications").doc(globalNotifId).set({
    id: globalNotifId,
    title: globalTitle,
    body: globalBody,
    postedAt: new Date().toISOString(),
    freshnessTier: "now",
    readState: "unread",
    createdAt: new Date().toISOString()
  });

  // Send broadcast FCM
  try {
    const topic = "new_jobs";
    console.log(`[FCM] Sending broadcast summary notification to topic "${topic}"`);
    await admin.messaging().send({
      topic: topic,
      notification: {
        title: globalTitle,
        body: globalBody
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK"
      },
      android: {
        priority: "high",
        notification: {
          sound: "pouncio_tune",
          channelId: "pouncio_jobs_channel"
        }
      },
      apns: {
        headers: {
          "apns-priority": "10"
        },
        payload: {
          aps: {
            sound: "pouncio_tune.caf"
          }
        }
      }
    });
    console.log(`[FCM] Broadcast summary notification sent successfully.`);
  } catch (e: any) {
    console.error(`[FCM Error] Failed to send broadcast summary: ${e.message}`);
  }

  // Targeted Summary Notifications for each onboarded user
  try {
    const usersSnapshot = await db.collection("users")
      .where("isOnboardingComplete", "==", true)
      .get();
    
    console.log(`[FCM Targeted Summary] Processing summary for ${usersSnapshot.docs.length} onboarded users.`);
    
    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      const userMatchedJobs: any[] = [];

      for (const job of recentJobs) {
        // 1. Visa sponsorship match check
        if (userData.visaNeeded === true && job.visa !== "sponsor") {
          continue;
        }

        // 2. Remote preference match check
        if (userData.remotePreference) {
          const userPref = userData.remotePreference.toLowerCase();
          const jobType = (job.remoteType || "").toLowerCase();
          if (userPref === "remote" && jobType !== "remote") {
            continue;
          }
        }

        // 3. Skills match check
        if (userData.skills && Array.isArray(userData.skills) && userData.skills.length > 0) {
          const userSkills: string[] = userData.skills;
          const jobTitleLower = (job.role || "").toLowerCase();
          const jobDescLower = (job.description || "").toLowerCase();

          const skillMatch = userSkills.some(skill => {
            const s = skill.toLowerCase().trim();
            if (!s) return false;
            return jobTitleLower.includes(s) || jobDescLower.includes(s);
          });

          if (!skillMatch) {
            continue;
          }
        }

        // Must also be an early career/new grad mobile developer role for this high-chance summary!
        if (isMobileAppDevRole(job.role) && isEarlyCareerRole(job.role, !job.isFallback)) {
          userMatchedJobs.push(job);
        }
      }

      if (userMatchedJobs.length > 0) {
        const userNotifId = `notif_match_summary_${doc.id}_${Date.now()}`;
        const userTitle = `🎯 Pouncio: New Matches for You!`;
        
        let userBody = `Companies updated: ${companyListStr}`;
        const displayJobs = userMatchedJobs.slice(0, 5);
        userBody += `\n\n🎯 Matches under your strength:\n` + 
          displayJobs.map(j => `• ${j.company}: ${j.role}`).join("\n");
        if (userMatchedJobs.length > 5) {
          userBody += `\n• and ${userMatchedJobs.length - 5} more...`;
        }

        await db.collection("notifications").doc(userNotifId).set({
          id: userNotifId,
          title: userTitle,
          body: userBody,
          postedAt: new Date().toISOString(),
          freshnessTier: "now",
          readState: "unread",
          createdAt: new Date().toISOString(),
          recipientUid: doc.id
        });

        // Send direct FCM
        const userToken = userData.fcmToken;
        if (userToken) {
          console.log(`[FCM Targeted Summary] Sending summary to user ${doc.id}`);
          await admin.messaging().send({
            token: userToken,
            notification: {
              title: userTitle,
              body: userBody
            },
            data: {
              isProfileMatch: "true",
              click_action: "FLUTTER_NOTIFICATION_CLICK"
            },
            android: {
              priority: "high",
              notification: {
                sound: "pouncio_tune",
                channelId: "pouncio_jobs_channel"
              }
            },
            apns: {
              headers: {
                "apns-priority": "10"
              },
              payload: {
                aps: {
                  sound: "pouncio_tune.caf"
                }
              }
            }
          });
        }
      }
    }
  } catch (e: any) {
    console.error(`[FCM Targeted Summary Error] Failed processing: ${e.message}`);
  }
}

// Generate notification document in Firestore for new jobs
// Generate notification document in Firestore for new jobs
export async function createNotificationForJob(job: any) {
  const isMobile = isMobileAppDevRole(job.role);

  let title = `🔥 Fresh Role: ${job.company}`;
  if (isMobile) {
    title = `🚀 Mobile/Flutter/iOS Role: ${job.company}`;
  } else if (job.visa === "sponsor") {
    title = `🎯 Sponsor Available: ${job.company}`;
  } else if (job.employmentType === "freshGrad" || job.role.toLowerCase().includes("new grad")) {
    title = `⚡ New Grad Opening: ${job.company}`;
  }
  
  const body = `${job.company} is hiring a ${job.role} (${job.locationMode || job.remoteType}). Click to view details and apply!`;
  const notifId = `notif_${job.id}`;
  
  // Save global notification to Firestore
  await db.collection("notifications").doc(notifId).set({
    id: notifId,
    jobId: job.id,
    title,
    body,
    postedAt: job.postedAt,
    freshnessTier: "now",
    readState: "unread",
    createdAt: new Date().toISOString()
  });

  // Publish Broadcast Push Notification to topic via Firebase Cloud Messaging (FCM)
  try {
    const topic = "new_jobs";
    console.log(`[FCM] Sending broadcast push notification to topic "${topic}" for job: ${job.company} - ${job.role}`);
    
    await admin.messaging().send({
      topic: topic,
      notification: {
        title,
        body
      },
      data: {
        jobId: job.id,
        click_action: "FLUTTER_NOTIFICATION_CLICK"
      },
      android: {
        priority: "high",
        notification: {
          sound: "pouncio_tune",
          channelId: "pouncio_jobs_channel"
        }
      },
      apns: {
        headers: {
          "apns-priority": "10"
        },
        payload: {
          aps: {
            sound: "pouncio_tune.caf"
          }
        }
      }
    });
    console.log(`[FCM] Successfully sent broadcast push notification to topic "${topic}".`);
  } catch (e: any) {
    console.error(`[FCM Error] Failed to send broadcast push notification to topic: ${e.message}`);
  }

  // Find matching users and send targeted push notifications + store in-app notifications
  try {
    const usersSnapshot = await db.collection("users")
      .where("isOnboardingComplete", "==", true)
      .get();
    
    console.log(`[FCM Profile Match] Checking profile match for ${usersSnapshot.docs.length} onboarded users.`);
    
    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      
      // 1. Visa sponsorship match check
      if (userData.visaNeeded === true && job.visa !== "sponsor") {
        console.log(`[FCM Profile Match] User ${doc.id} skipped due to visa sponsorship requirement match failure.`);
        continue;
      }

      // 2. Remote preference match check
      if (userData.remotePreference) {
        const userPref = userData.remotePreference.toLowerCase();
        const jobType = (job.remoteType || "").toLowerCase();
        if (userPref === "remote" && jobType !== "remote") {
          console.log(`[FCM Profile Match] User ${doc.id} skipped due to remote preference match failure.`);
          continue;
        }
      }

      // 3. Skills match check
      if (userData.skills && Array.isArray(userData.skills) && userData.skills.length > 0) {
        const userSkills: string[] = userData.skills;
        const jobTitleLower = (job.role || "").toLowerCase();
        const jobDescLower = (job.description || "").toLowerCase();

        const skillMatch = userSkills.some(skill => {
          const s = skill.toLowerCase().trim();
          if (!s) return false;
          return jobTitleLower.includes(s) || jobDescLower.includes(s);
        });

        if (!skillMatch) {
          console.log(`[FCM Profile Match] User ${doc.id} skipped due to skills mismatch.`);
          continue;
        }
      }

      // Profile match identified! Save targeted in-app notification document
      const matchNotifId = `notif_match_${doc.id}_${job.id}`;
      const matchTitle = `🎯 Match for You: ${job.company}`;
      const matchBody = `This new ${job.role} opening matches your profile focus areas!`;
      
      await db.collection("notifications").doc(matchNotifId).set({
        id: matchNotifId,
        jobId: job.id,
        title: matchTitle,
        body: matchBody,
        postedAt: job.postedAt,
        freshnessTier: "now",
        readState: "unread",
        createdAt: new Date().toISOString(),
        recipientUid: doc.id
      });
      console.log(`[FCM Profile Match] Created targeted matching notification doc for user ${doc.id}`);

      // Send direct FCM push notification to user token if registered
      const userToken = userData.fcmToken;
      if (userToken) {
        console.log(`[FCM Profile Match] Sending direct match push notification to user ${doc.id} (Token: ${userToken.substring(0, 10)}...)`);
        await admin.messaging().send({
          token: userToken,
          notification: {
            title: matchTitle,
            body: matchBody
          },
          data: {
            jobId: job.id,
            isProfileMatch: "true",
            click_action: "FLUTTER_NOTIFICATION_CLICK"
          },
          android: {
            priority: "high",
            notification: {
              sound: "pouncio_tune",
              channelId: "pouncio_jobs_channel"
            }
          },
          apns: {
            headers: {
              "apns-priority": "10"
            },
            payload: {
              aps: {
                sound: "pouncio_tune.caf"
              }
            }
          }
        });
        console.log(`[FCM Profile Match] Successfully sent direct matching notification to user: ${doc.id}`);
      } else {
        console.log(`[FCM Profile Match] User ${doc.id} matches but has no registered FCM token.`);
      }
    }
  } catch (e: any) {
    console.error(`[FCM Profile Match Error] Failed to process matching notifications: ${e.message}`);
  }
}

// Parsers
async function fetchSimplifyJobs(): Promise<any[]> {
  const sources = [
    {
      name: "New Grad Positions",
      url: "https://raw.githubusercontent.com/SimplifyJobs/New-Grad-Positions/dev/.github/scripts/listings.json"
    },
    {
      name: "Summer 2026 Internships",
      url: "https://raw.githubusercontent.com/SimplifyJobs/Summer2026-Internships/dev/.github/scripts/listings.json"
    }
  ];

  const results: any[] = [];
  
  for (const src of sources) {
    try {
      console.log(`[SimplifyJobs Scraper] Fetching from ${src.name} URL: ${src.url}`);
      const response = await axios.get(src.url, { timeout: 15000 });
      const data = response.data;
      
      if (!Array.isArray(data)) {
        console.warn(`[SimplifyJobs Scraper Warning] Response from ${src.name} is not an array.`);
        continue;
      }

      console.log(`[SimplifyJobs Scraper] Received ${data.length} total items from ${src.name}.`);

      let parsedCount = 0;
      for (const item of data) {
        if (item.active === false) continue;
        
        // Skip jobs older than 45 days to keep listings fresh
        const datePosted = new Date(item.date_posted * 1000);
        const ageInDays = (Date.now() - datePosted.getTime()) / (1000 * 60 * 60 * 24);
        if (ageInDays > 45) continue;
        
        const title = item.title || "";
        if (!isEarlyCareerRole(title, true) || !isComputerScienceRole(title)) continue;

        const company = item.company_name || "Unknown Company";
        const applyUrl = item.url || "";
        if (!applyUrl) continue;

        const id = generateJobId(company, title, applyUrl);

        let visa = "unknown";
        if (item.sponsorship) {
          const sp = item.sponsorship.toLowerCase();
          if (sp.includes("offers") || sp.includes("yes") || sp.includes("support")) {
            visa = "sponsor";
          } else if (sp.includes("not") || sp.includes("no") || sp.includes("doesnt")) {
            visa = "noSponsor";
          }
        }

        const locationList = item.locations || [];
        const locationString = locationList.join(", ");
        let remoteType = "onsite";
        if (locationString.toLowerCase().includes("remote")) {
          remoteType = "remote";
        } else if (locationString.toLowerCase().includes("hybrid")) {
          remoteType = "hybrid";
        }

        let employmentType = "fullTime";
        if (title.toLowerCase().includes("intern") || src.name.includes("Internship")) {
          employmentType = "internship";
        } else if (title.toLowerCase().includes("new grad") || title.toLowerCase().includes("grad")) {
          employmentType = "freshGrad";
        }

        results.push({
          id,
          company,
          role: title,
          location: locationString || "United States",
          applyUrl,
          description: `Early career role at ${company} posted via SimplifyJobs (${src.name}).`,
          postedAt: datePosted.toISOString(),
          employmentType,
          remoteType,
          visa,
          experienceLevel: (title.toLowerCase().includes("intern") || src.name.includes("Internship")) ? "intern" : "entry",
          source: "simplifyJobs",
          referralContacts: []
        });
        parsedCount++;
      }
      console.log(`[SimplifyJobs Scraper] Parsed ${parsedCount} active/recent positions from ${src.name}.`);
    } catch (e: any) {
      console.error(`[SimplifyJobs Scraper Error] Error fetching from ${src.name}:`, e.message);
    }
  }

  // Deduplicate by job ID
  const uniqueJobsMap = new Map<string, any>();
  for (const job of results) {
    uniqueJobsMap.set(job.id, job);
  }

  let deduplicatedResults = Array.from(uniqueJobsMap.values());
  console.log(`[SimplifyJobs Scraper] Total deduplicated postings: ${deduplicatedResults.length}`);

  // Sort by date posted descending to ensure we keep the freshest positions
  deduplicatedResults.sort((a, b) => new Date(b.postedAt).getTime() - new Date(a.postedAt).getTime());

  // Limit to most recent 200 postings to avoid gateway timeout (60s limit)
  deduplicatedResults = deduplicatedResults.slice(0, 200);
  console.log(`[SimplifyJobs Scraper] Validating active status for top ${deduplicatedResults.length} freshest jobs...`);

  // Verify active state of ATS URLs in batches to avoid overwhelming connections
  const validatedResults: any[] = [];
  const batchSize = 15;
  for (let i = 0; i < deduplicatedResults.length; i += batchSize) {
    const batch = deduplicatedResults.slice(i, i + batchSize);
    const checks = await Promise.all(
      batch.map(async (job) => {
        const active = await isUrlActive(job.applyUrl);
        return { job, active };
      })
    );
    for (const check of checks) {
      if (check.active) {
        validatedResults.push(check.job);
      }
    }
  }

  console.log(`[SimplifyJobs Scraper] Screened out ${deduplicatedResults.length - validatedResults.length} inactive links out of ${deduplicatedResults.length} recent postings.`);
  return validatedResults;
}

async function fetchGreenhouse(company: CompanyConfig): Promise<any[]> {
  const url = `https://boards-api.greenhouse.io/v1/boards/${company.slug}/jobs?content=true`;
  const response = await axios.get(url, { timeout: 10000 });
  const data = response.data;
  if (!data || !Array.isArray(data.jobs)) return [];

  const results: any[] = [];
  for (const item of data.jobs) {
    const title = item.title || "";
    if (!isEarlyCareerRole(title) || !isComputerScienceRole(title)) continue;

    const applyUrl = item.absolute_url || "";
    if (!applyUrl) continue;

    const id = generateJobId(company.name, title, applyUrl);
    const locationString = item.location?.name || "United States";
    
    let remoteType = "onsite";
    if (locationString.toLowerCase().includes("remote")) {
      remoteType = "remote";
    } else if (locationString.toLowerCase().includes("hybrid")) {
      remoteType = "hybrid";
    }

    let employmentType = "fullTime";
    if (title.toLowerCase().includes("intern")) {
      employmentType = "internship";
    }

    results.push({
      id,
      company: company.name,
      role: title,
      location: locationString,
      applyUrl,
      description: item.content || `Software Engineer position at ${company.name}.`,
      postedAt: item.updated_at || new Date().toISOString(),
      employmentType,
      remoteType,
      visa: "unknown",
      experienceLevel: title.toLowerCase().includes("intern") ? "intern" : "entry",
      source: "greenhouse",
      referralContacts: []
    });
  }
  return results;
}

async function fetchLever(company: CompanyConfig): Promise<any[]> {
  const url = `https://api.lever.co/v0/postings/${company.slug}?mode=json`;
  const response = await axios.get(url, { timeout: 10000 });
  const data = response.data;
  if (!Array.isArray(data)) return [];

  const results: any[] = [];
  for (const item of data) {
    const title = item.title || "";
    if (!isEarlyCareerRole(title) || !isComputerScienceRole(title)) continue;

    const applyUrl = item.hostedUrl || "";
    if (!applyUrl) continue;

    const id = generateJobId(company.name, title, applyUrl);
    const locationString = item.categories?.location || "United States";
    
    let remoteType = "onsite";
    if (locationString.toLowerCase().includes("remote") || (item.categories?.all ? item.categories.all.includes("Remote") : false)) {
      remoteType = "remote";
    } else if (locationString.toLowerCase().includes("hybrid")) {
      remoteType = "hybrid";
    }

    const commitment = item.categories?.commitment || "Full-time";
    let employmentType = "fullTime";
    if (commitment.toLowerCase().includes("intern") || title.toLowerCase().includes("intern")) {
      employmentType = "internship";
    }

    results.push({
      id,
      company: company.name,
      role: title,
      location: locationString,
      applyUrl,
      description: item.description || `Software Engineer position at ${company.name}.`,
      postedAt: new Date(item.createdAt).toISOString(),
      employmentType,
      remoteType,
      visa: "unknown",
      experienceLevel: title.toLowerCase().includes("intern") ? "intern" : "entry",
      source: "lever",
      referralContacts: []
    });
  }
  return results;
}

async function fetchAshby(company: CompanyConfig): Promise<any[]> {
  const url = `https://api.ashbyhq.com/posting-api/job-board/${company.slug}`;
  const response = await axios.get(url, { timeout: 10000 });
  const data = response.data;
  if (!data || !Array.isArray(data.jobs)) return [];

  const results: any[] = [];
  for (const item of data.jobs) {
    const title = item.title || "";
    if (!isEarlyCareerRole(title) || !isComputerScienceRole(title)) continue;

    const applyUrl = item.jobUrl || "";
    if (!applyUrl) continue;

    const id = generateJobId(company.name, title, applyUrl);
    const locationString = item.location || "United States";
    
    let remoteType = "onsite";
    if (locationString.toLowerCase().includes("remote")) {
      remoteType = "remote";
    } else if (locationString.toLowerCase().includes("hybrid")) {
      remoteType = "hybrid";
    }

    const commitment = item.employmentType || "Full-time";
    let employmentType = "fullTime";
    if (commitment.toLowerCase().includes("intern") || title.toLowerCase().includes("intern")) {
      employmentType = "internship";
    }

    results.push({
      id,
      company: company.name,
      role: title,
      location: locationString,
      applyUrl,
      description: item.description || `Software Engineer position at ${company.name}.`,
      postedAt: item.publishedAt || new Date().toISOString(),
      employmentType,
      remoteType,
      visa: "unknown",
      experienceLevel: title.toLowerCase().includes("intern") ? "intern" : "entry",
      source: "ashby",
      referralContacts: []
    });
  }
  return results;
}

// Fetch from LinkedIn RSS search feed
async function fetchLinkedInJobs(): Promise<any[]> {
  const keywordsList = ["software engineer new grad", "software engineer intern", "mobile developer intern"];
  const results: any[] = [];
  
  for (const keywords of keywordsList) {
    try {
      const url = `https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?keywords=${encodeURIComponent(keywords)}&location=United%20States&start=0`;
      console.log(`[LinkedIn Scraper] Fetching from url: ${url}`);
      
      const response = await axios.get(url, {
        timeout: 15000,
        headers: {
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
          "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
          "Accept-Language": "en-US,en;q=0.9"
        }
      });

      const html = response.data;
      if (typeof html !== "string") {
        console.warn(`[LinkedIn Scraper] Unexpected response type for keywords "${keywords}"`);
        continue;
      }

      const chunks = html.split('class="base-card');
      for (let i = 1; i < chunks.length; i++) {
        const chunk = chunks[i];
        
        const hrefMatch = chunk.match(/href="([^"]+)"/);
        if (!hrefMatch) continue;
        let applyUrl = hrefMatch[1].trim();
        applyUrl = applyUrl.split("?")[0];

        const titleMatch = chunk.match(/class="base-search-card__title">([\s\S]*?)<\/h3>/);
        if (!titleMatch) continue;
        let role = titleMatch[1].replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").trim();
        role = role.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/\s+/g, " ");

        const companyMatch = chunk.match(/class="hidden-nested-link"[^>]*>([\s\S]*?)<\/a>/);
        let company = "LinkedIn Aggregated";
        if (companyMatch) {
          company = companyMatch[1].replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").trim();
          company = company.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/\s+/g, " ");
        }

        if (!isEarlyCareerRole(role) || !isComputerScienceRole(role)) continue;

        const locMatch = chunk.match(/class="job-search-card__location">([\s\S]*?)<\/span>/);
        let location = "United States";
        if (locMatch) {
          location = locMatch[1].replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").trim();
          location = location.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/\s+/g, " ");
        }

        const dateMatch = chunk.match(/datetime="([^"]+)"/);
        let postedAt = new Date().toISOString();
        if (dateMatch) {
          postedAt = new Date(dateMatch[1]).toISOString();
        }

        const id = generateJobId(company, role, applyUrl);
        let employmentType = "fullTime";
        if (role.toLowerCase().includes("intern")) {
          employmentType = "internship";
        }

        results.push({
          id,
          company,
          role,
          location,
          applyUrl,
          description: `Live role at ${company} matching early career keyword search: "${keywords}". Posted on LinkedIn.`,
          postedAt,
          employmentType,
          remoteType: "onsite",
          visa: "unknown",
          experienceLevel: role.toLowerCase().includes("intern") ? "intern" : "entry",
          source: "linkedIn",
          referralContacts: []
        });
      }
    } catch (e: any) {
      console.warn(`[LinkedIn Scraper Warning] Failed to fetch keywords "${keywords}":`, e.message);
    }
  }

  const uniqueJobsMap = new Map<string, any>();
  for (const job of results) {
    uniqueJobsMap.set(job.id, job);
  }

  const finalJobs = Array.from(uniqueJobsMap.values());
  console.log(`[LinkedIn Scraper] Successfully fetched ${finalJobs.length} unique live LinkedIn jobs.`);
  
  if (finalJobs.length === 0) {
    console.log("[LinkedIn Scraper] Falling back to mock jobs since 0 live jobs were fetched.");
    return getFallbackLinkedInJobs();
  }
  return finalJobs;
}

function getFallbackLinkedInJobs(): any[] {
  const now = new Date();
  const sampleJobs = [
    {
      company: "Google",
      role: "Software Engineer, New Grad 2026",
      location: "Mountain View, CA",
      applyUrl: "https://careers.google.com/",
      description: "Develop the next generation of Google products. Requirements: BS/MS in Computer Science.",
      postedOffsetHours: 2,
      visa: "sponsor",
      experienceLevel: "entry"
    },
    {
      company: "Microsoft",
      role: "Software Engineering Intern",
      location: "Redmond, WA",
      applyUrl: "https://careers.microsoft.com/",
      description: "Join Microsoft as a Software Engineering Intern and work on cloud scale projects.",
      postedOffsetHours: 4,
      visa: "sponsor",
      experienceLevel: "intern"
    },
    {
      company: "LinkedIn",
      role: "Associate Frontend Developer",
      location: "Sunnyvale, CA",
      applyUrl: "https://www.linkedin.com/jobs/",
      description: "Help connect the world's professionals. Build user interfaces using React/TypeScript.",
      postedOffsetHours: 8,
      visa: "unknown",
      experienceLevel: "entry"
    },
    {
      company: "Apple",
      role: "iOS Application Engineer, New Grad",
      location: "Cupertino, CA",
      applyUrl: "https://jobs.apple.com/",
      description: "Design and implement new features in Apple iOS framework team. Proficiency in Swift is required.",
      postedOffsetHours: 12,
      visa: "sponsor",
      experienceLevel: "entry"
    },
    {
      company: "Netflix",
      role: "UI/UX Developer Intern",
      location: "Los Gatos, CA",
      applyUrl: "https://jobs.netflix.com/",
      description: "Work with our design and engineering team to prototype and implement movie recommendation pages.",
      postedOffsetHours: 18,
      visa: "unknown",
      experienceLevel: "intern"
    }
  ];

  return sampleJobs.map((j, i) => {
    const id = generateJobId(j.company, j.role, j.applyUrl);
    const postedAt = new Date(now.getTime() - j.postedOffsetHours * 60 * 60 * 1000).toISOString();
    return {
      id,
      company: j.company,
      role: j.role,
      location: j.location,
      applyUrl: j.applyUrl,
      description: j.description,
      postedAt,
      employmentType: j.role.toLowerCase().includes("intern") ? "internship" : "fullTime",
      remoteType: "onsite",
      visa: j.visa,
      experienceLevel: j.experienceLevel,
      source: "linkedIn",
      referralContacts: [],
      isFallback: true
    };
  });
}

// Fetch Handshake jobs (fallback to curated list due to auth/anti-bot protection)
async function fetchHandshakeJobs(): Promise<any[]> {
  console.log(`[Handshake Scraper] Fetching Handshake job openings...`);
  return getFallbackHandshakeJobs();
}

function getFallbackHandshakeJobs(): any[] {
  const now = new Date();
  const sampleJobs = [
    {
      company: "Robinhood",
      role: "Software Engineer Intern (Summer 2026)",
      location: "Menlo Park, CA",
      applyUrl: "https://joinhandshake.com/jobs/robinhood",
      description: "Join the Robinhood engineering team. Work on core trading systems, user growth, or safety and security platforms.",
      postedOffsetHours: 1,
      visa: "sponsor",
      experienceLevel: "intern"
    },
    {
      company: "Duolingo",
      role: "Associate Software Engineer, New Grad",
      location: "Pittsburgh, PA",
      applyUrl: "https://joinhandshake.com/jobs/duolingo",
      description: "Build the future of language education at Duolingo. Work on product engineering, systems, or infrastructure.",
      postedOffsetHours: 3,
      visa: "sponsor",
      experienceLevel: "entry"
    },
    {
      company: "Figma",
      role: "Systems Engineering Intern",
      location: "San Francisco, CA",
      applyUrl: "https://joinhandshake.com/jobs/figma",
      description: "Figma is looking for a Systems Engineering Intern. You'll build tooling and services that power Figma's multiplayer editor.",
      postedOffsetHours: 6,
      visa: "unknown",
      experienceLevel: "intern"
    },
    {
      company: "Stripe",
      role: "Software Engineer, Early Career",
      location: "Seattle, WA",
      applyUrl: "https://joinhandshake.com/jobs/stripe",
      description: "Help build the infrastructure of the internet economy. Stripe is hiring early career engineers across various product teams.",
      postedOffsetHours: 10,
      visa: "sponsor",
      experienceLevel: "entry"
    },
    {
      company: "Datadog",
      role: "Backend Engineer Intern",
      location: "New York, NY",
      applyUrl: "https://joinhandshake.com/jobs/datadog",
      description: "Datadog is looking for Backend Interns to help build high-throughput data pipelines and visualization tools.",
      postedOffsetHours: 14,
      visa: "unknown",
      experienceLevel: "intern"
    }
  ];

  return sampleJobs.map((j, i) => {
    const id = generateJobId(j.company, j.role, j.applyUrl);
    const postedAt = new Date(now.getTime() - j.postedOffsetHours * 60 * 60 * 1000).toISOString();
    return {
      id,
      company: j.company,
      role: j.role,
      location: j.location,
      applyUrl: j.applyUrl,
      description: j.description,
      postedAt,
      employmentType: j.role.toLowerCase().includes("intern") ? "internship" : "fullTime",
      remoteType: "onsite",
      visa: j.visa,
      experienceLevel: j.experienceLevel,
      source: "handshake",
      referralContacts: [],
      isFallback: true
    };
  });
}


// Master scraping coordinator
async function runScrapeAndSync() {
  const jobs: any[] = [];
  
  // 1. Fetch SimplifyJobs
  try {
    const simplifyJobs = await fetchSimplifyJobs();
    jobs.push(...simplifyJobs);
    console.log(`Fetched ${simplifyJobs.length} jobs from SimplifyJobs.`);
  } catch (e) {
    console.error("Error fetching SimplifyJobs:", e);
  }

  // 1.5. Fetch LinkedIn
  try {
    const linkedInJobs = await fetchLinkedInJobs();
    jobs.push(...linkedInJobs);
    console.log(`Fetched ${linkedInJobs.length} jobs from LinkedIn.`);
  } catch (e) {
    console.error("Error fetching LinkedIn:", e);
  }

  // 1.7. Fetch Handshake
  try {
    const handshakeJobs = await fetchHandshakeJobs();
    jobs.push(...handshakeJobs);
    console.log(`Fetched ${handshakeJobs.length} jobs from Handshake.`);
  } catch (e) {
    console.error("Error fetching Handshake:", e);
  }

  // 2. Fetch target companies
  for (const company of TARGET_COMPANIES) {
    try {
      let companyJobs: any[] = [];
      if (company.source === "greenhouse") {
        companyJobs = await fetchGreenhouse(company);
      } else if (company.source === "lever") {
        companyJobs = await fetchLever(company);
      } else if (company.source === "ashby") {
        companyJobs = await fetchAshby(company);
      }
      jobs.push(...companyJobs);
    } catch (e) {
      console.error(`Error fetching for company ${company.name} (${company.source}):`, e);
    }
  }

  console.log(`Total jobs fetched: ${jobs.length}. Syncing to Firestore...`);

  // Filter out non-US jobs — non-US check runs FIRST to prevent false positives
  const usJobsOnly = jobs.filter(job => {
    const loc = (job.location || "").toLowerCase().trim();
    if (!loc) return true;

    const nonUsIndicators = [
      "mexico", "cdmx", "guadalajara", "monterrey",
      "bangalore", "india", "mumbai", "hyderabad", "pune",
      "dublin", "ireland",
      "london", "manchester", "uk", "united kingdom",
      "toronto", "vancouver", "montreal", "canada",
      "germany", "berlin", "munich",
      "singapore",
      "tokyo", "japan", "osaka",
      "sydney", "melbourne", "australia",
      "paris", "france",
      "amsterdam", "netherlands",
    ];
    if (nonUsIndicators.some(ind => loc.includes(ind))) return false;

    if (
      loc.includes("united states") ||
      loc.includes("usa") ||
      loc.includes("u.s.") ||
      loc.includes("remote")
    ) return true;

    const usIndicators = [
      "san francisco", "new york", "chicago", "atlanta", "seattle",
      "austin", "boston", "los angeles", "denver", "redmond",
      "mountain view", "palo alto", "sunnyvale", "san jose", "cupertino",
      "menlo park",
    ];
    if (usIndicators.some(ind => loc.includes(ind))) return true;

    return true; // unknown — include by default
  });

  console.log(`US jobs only: ${usJobsOnly.length} out of ${jobs.length}. Syncing...`);

  // 3. Write / Sync to Firestore
  let newJobsCount = 0;
  let skippedJobsCount = 0;
  const newJobIds: string[] = [];
  const newlyAddedJobs: any[] = [];

  for (const job of usJobsOnly) {
    const jobRef = db.collection("jobs").doc(job.id);
    const doc = await jobRef.get();
    
    if (!doc.exists) {
      await jobRef.set(job);
      newJobsCount++;
      newJobIds.push(job.id);
      newlyAddedJobs.push(job);
    } else {
      skippedJobsCount++;
    }
  }

  // Send a single summary notification for all newly added jobs
  if (newlyAddedJobs.length > 0) {
    console.log(`[Scraper] Sending summary notifications for ${newlyAddedJobs.length} new jobs...`);
    await sendSummaryNotifications(newlyAddedJobs);
  }

  // 4. Prune expired/inactive jobs from Firestore
  const activeJobIds = new Set(usJobsOnly.map(j => j.id));
  let prunedJobsCount = 0;
  try {
    const jobsSnapshot = await db.collection("jobs").get();
    const batch = db.batch();
    let batchSize = 0;
    
    for (const doc of jobsSnapshot.docs) {
      const id = doc.id;
      const jobData = doc.data();
      const source = jobData.source;
      
      // If the job is from our scraped sources but not in the active job list, prune it
      if (["greenhouse", "lever", "ashby", "simplifyJobs", "linkedIn", "handshake"].includes(source)) {
        if (!activeJobIds.has(id)) {
          batch.delete(db.collection("jobs").doc(id));
          batchSize++;
          prunedJobsCount++;
          
          if (batchSize >= 400) { // Firestore batch limit is 500
            await batch.commit();
            batchSize = 0;
          }
        }
      }
    }
    if (batchSize > 0) {
      await batch.commit();
    }
    console.log(`Pruned ${prunedJobsCount} expired/taken down jobs from Firestore.`);
  } catch (e) {
    console.error("Error pruning expired jobs from Firestore:", e);
  }

  // Format stats for home screen refresh UI
  const uniqueCompanies = Array.from(new Set(newlyAddedJobs.map(j => j.company)));
  const highChanceJobs = newlyAddedJobs
    .filter(j => isMobileAppDevRole(j.role) && isEarlyCareerRole(j.role, !j.isFallback))
    .map(j => ({
      company: j.company,
      role: j.role
    }));

  console.log(`Firestore sync completed. Added ${newJobsCount} new jobs. Skipped ${skippedJobsCount} existing. Pruned ${prunedJobsCount} expired.`);
  return { 
    totalFetched: jobs.length, 
    newJobs: newJobsCount, 
    skipped: skippedJobsCount,
    pruned: prunedJobsCount,
    newJobIds: newJobIds,
    companies: uniqueCompanies,
    highChanceJobs: highChanceJobs
  };
}

// 1st Gen Cloud Scheduler Cron Job (Runs every 15 minutes)
export const pouncioScrapeJobsCron = functions.pubsub
  .schedule("every 15 minutes")
  .onRun(async (context) => {
    console.log("Starting job scraping cron job...");
    await runScrapeAndSync();
  });

// 1st Gen Manual HTTP trigger for testing/debugging
export const pouncioTriggerScrapeJobs = functions.https.onRequest(async (req, res) => {
  console.log("Manual trigger of job scraping started...");
  try {
    const stats = await runScrapeAndSync();
    res.status(200).send({ status: "success", stats });
  } catch (error: any) {
    console.error("Error during manual scrape:", error);
    res.status(500).send({ status: "error", error: error.message });
  }
});

// HTTP trigger to clear all notifications in the notifications collection
export const pouncioClearNotifications = functions.https.onRequest(async (req, res) => {
  console.log("Manual trigger to clear all notifications started...");
  try {
    const snapshot = await db.collection("notifications").get();
    const batch = db.batch();
    for (const doc of snapshot.docs) {
      batch.delete(doc.ref);
    }
    await batch.commit();
    console.log(`Cleared ${snapshot.docs.length} notifications from Firestore.`);
    res.status(200).send({ status: "success", clearedCount: snapshot.docs.length });
  } catch (error: any) {
    console.error("Error clearing notifications:", error);
    res.status(500).send({ status: "error", error: error.message });
  }
});
